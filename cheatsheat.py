def unknown():
	N = int(input())
	A = list(map(int, input().split()))
	max = 0
	K = 0
	for i in range(N-1, -1, -1):
		if A[i] > max:
			max = A[i]
			K += 1
	print(K)

def exclude ():
	N, M = map(int, input().split())
	Ln  = map(int, input().split())
	Lm = set(map(int, input().split()))
	print(*(str(i) for i in Ln if i not in Lm))

def adj_list_mat(G):
	N = len(G)
	"Creates [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]"
	M = [[0]*N for i in range(N)] 
	for j in range(N):
		for k in G[j]:
			M[j][k] = 1
	return M

def out_degree(M,u): 
	c = 0
	for i in range(len(M)):
		if M[u][i] == 1:
			c = c + 1
	return c

def out_degree2(M, u):
    """ O(n) where n == len(M[u]) == len(M[0]) """
    return sum(M[u])

def in_degree2(M, u):
    """ O(n) where n == len(M)"""
    return sum(M[i][u] for i in range(len(M)))

def in_degree(M,u):
	c = 0
	for i in range(len(M)):
		if M[i][u] == 1:
			c = c + 1
	return c

def test():
    G = [
        [1, 2],
        [0],
        [0, 1, 3],
        [0]
    ]
    M = adj_list_mat(G)
    for row in M:
        print(row)
    print(out_degree(M, 2)) #expected: 3
    print(in_degree(M, 2)) #expected: 1

"O(N) kanonikh 2020b"
def count_substr(s,k):
		N = len(s)
		i = 0
		x = set()
		while(i+k-1 < N):
			x.add(s[i:i+k])
			i = i + 1
		print(len(x))

def countsumk_ON(A, K):
	seen = {0: 1}
	sum = result = 0
	for x in A:
		sum += x
		if sum - K in seen:
			result += seen[sum - K]
		if sum in seen:
			seen[sum] += 1
		else:
			seen[sum] = 1
	return result

def countsumk_ON2(A, K):
	N = len(A)
	result = 0
	for i in range(N):
		sum = 0
		for j in range(i, N):
			sum += A[j]
			if sum == K: result += 1
	return result

