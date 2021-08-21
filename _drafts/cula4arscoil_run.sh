for i in 'https://www.youtube.com/watch?v=2wRhuVqvSaM&list=PLbcLsUBW9b3DvFSKW94bXDkVT0rIIbDTk' \
         'https://www.youtube.com/watch?v=xXHYMK6QXOw&list=PLbcLsUBW9b3ArxQoB-GhdSzGtYhhU-KGT' \
         'https://www.youtube.com/watch?v=eruwpozulxg&list=PLbcLsUBW9b3CZJpM59kQ76Wxdfm3buABK' \
         'https://www.youtube.com/watch?v=x_reXmDA5Io&list=PLbcLsUBW9b3ATOk7Kdzxb5KGM1wOFmwby' \
         'https://www.youtube.com/watch?v=tEooqp6hca4&list=PLbcLsUBW9b3DknBLzIWl0tRC_jYpmYdc5' \
         'https://www.youtube.com/watch?v=Ro8wbFTbdSE&list=PLbcLsUBW9b3B0D2MrdXYyxT9kgADvHfIJ' \
         'https://www.youtube.com/watch?v=HCgtEv_cjr8&list=PLbcLsUBW9b3AgMxkiet3mnzspREWj6o54' \
         'https://www.youtube.com/watch?v=7O04xzY4XRU&list=PLbcLsUBW9b3BWCOmTz3PNNsH2B71h2EeR' \
         'https://www.youtube.com/watch?v=YGm0qiiY2_s&list=PLbcLsUBW9b3A-N-5701r8dhxstLqBQFKm' \
         'https://www.youtube.com/watch?v=J6Ek46HChd0&list=PLbcLsUBW9b3CZAzppIH9EidEIIvNdZFsL' \
         'https://www.youtube.com/playlist?list=PLbcLsUBW9b3B5DD8uXW0rJySgsqAeed1C' \
         'https://www.youtube.com/playlist?list=PLbcLsUBW9b3DVprPwU4hHT73VdmmY45bc' \
         'https://www.youtube.com/playlist?list=PLbcLsUBW9b3AcCrGgD04ryY6bnN8h7GSr' \
         'https://www.youtube.com/playlist?list=PLbcLsUBW9b3COzIi5Rnl0F9yRZVR3tf_1' \
         'https://www.youtube.com/playlist?list=PLbcLsUBW9b3BHkhYBvNIlQknE-wpBT5vp' \
         'https://www.youtube.com/playlist?list=PLbcLsUBW9b3AJVck8CCw35QGPYHxPXi-F'
do
	youtube-dl -i -o '%(id)s.%(ext)s' $i 
done
