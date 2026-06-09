import os, sys, getopt
from pymo.parsers import BVHParser
from pymo.writers import *
from pymo.preprocessing import *
from pymo.viz_tools import *
import csv
import scipy.io.wavfile as wav

def render_video(bvh_data, fname):
    # write bvh and skeleton motion
    pos = MocapParameterizer('position').fit_transform([bvh_data])[0]
    print('writing:' + fname)
    render_mp4(pos, fname, axis_scale=200)

#Trim end of take
def trim_bvh_wav(basedir,file,render=False):
    offs_file = f"{basedir}/offset/{file}.wav.offset"
    with open(offs_file, 'r') as f:
        cvsreader = csv.reader(f)
        for row in cvsreader:
            offs = float(row[0])
            break
    print("offset=" + str(offs))
    bvh_file = f"{basedir}/bvh/{file}.bvh"
    p = BVHParser()
    bvh = p.parse(bvh_file)
    
    wav_file = f"{basedir}/wav_48k/{file}.wav"
    fs,X = wav.read(wav_file)    
    
    #Trim bvh start to offset
    offs_frames = int(np.round(offs/bvh.framerate))
    print(f"trimming {offs_frames} frames in bvh file")
    #FIXME check if datetime indecies needs to be reassigned... 
    bvh.values=bvh.values[offs_frames:]

    # Check which is longest, wav or bvh
    bvh_end_s = len(bvh.values)*bvh.framerate
    wav_end_s = len(X)/fs
    print(f"bvh_end_s={bvh_end_s}")
    print(f"wav_end_s={wav_end_s}")
    if bvh_end_s<wav_end_s:
        # trim audio
        end_wav = int(np.round(bvh_end_s*fs))
        X = X[:end_wav]
        wav.write(f"{basedir}/out/{file}.wav", fs, X)
        
        # write bvh
        writer = BVHWriter()
        with open(f"{basedir}/out/{file}.bvh",'w') as f:
            writer.write(bvh, f)
    else:
        # write bvh
        end_bvh = int(np.round(wav_end_s/bvh.framerate))
        bvh.values = bvh.values[:end_bvh]
        print(f"end_bvh={end_bvh}")
        writer = BVHWriter()
        with open(f"{basedir}/out/{file}.bvh",'w') as f:
            writer.write(bvh, f)
            
        # write audio
        wav.write(f"{basedir}/out/{file}.wav", fs, X)
    if render:
        new_fps = 30
        end_t = 10
        max_len = end_t*new_fps
        bvh_o = DownSampler(new_fps).fit_transform([bvh])[0]
        bvh_o.values=bvh_o.values[:max_len]
        render_video(bvh_o, f"{basedir}/out/{file}.mp4")
        os.system(f'ffmpeg -i {basedir}/out/{file}.mp4 -i {basedir}/out/{file}.wav -t {end_t} {basedir}/out/{file}_music.mp4')
        
def main():
    argv = sys.argv[1:]
    try:
        opts, args = getopt.getopt(argv,"br",["basedir=", "render="])
    except getopt.GetoptError:
        print ('python trimtakes.py -b basedir -r render')
        
        sys.exit(2)

    render = False
    for opt, arg in opts:
        if opt == '-h':
            print ('python trimtakes.py -b basedir -r render')
            print ('example usage: python synthesize.py --basedir=data --render=true')
            sys.exit()
        elif opt in ("-b", "--basedir"):
            basedir = arg
        elif opt in ("-r", "--render"):
            render = arg.lower()=="true" 
            
    outdir=os.path.join(basedir, "out")
    if not os.path.exists(outdir):
        os.makedirs(outdir)
    
    # r=root, d=directories, f = files
    for r, d, f in os.walk(os.path.join(basedir, "bvh")):
        for file in f:
            if file.endswith('.bvh'):
                ff=os.path.join(r, file)
                basename = os.path.splitext(os.path.basename(ff))[0]
                trim_bvh_wav(basedir,basename,render)

if __name__ == '__main__':
    main()

