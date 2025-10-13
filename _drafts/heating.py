import torch

device = "cuda"
size = 20000
a = torch.randn(size, size, device=device)
b = torch.randn(size, size, device=device)

while True:
    c = torch.matmul(a, b)
    torch.cuda.synchronize()
