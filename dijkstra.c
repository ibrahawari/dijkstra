#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>

#define NUM 20
#define LEN 60
#define INF 1000000

int *dijkstra(int, char *, char *, char **, int (*)[NUM * 2]);

main()
{
	char u[NUM][LEN], v[NUM][LEN];   
	int w[NUM];
	char tmp[LEN], tmpint[LEN];
	int i, j, k, size, d;
	char *p[NUM * 2];
	int m[NUM * 2][NUM * 2];
	char st[LEN], fn[LEN];
	int *data;
	char *path[NUM * 2];

	printf("Enter up to 20 paths in the format CITY1 CITY2 LENGTH:\n");
	for (i = 0; i < NUM; ++i) {
		fgets(tmp, LEN, stdin);
		if (tmp[3] == '\n')
			break;
		j = 0;
		for (k = 0; tmp[k] != ' '; ++k) {
			u[i][j] = tmp[k];  
			++j;
		}
		u[i][j] = '\0';
		j = 0;
		for (k = k + 1; tmp[k] != ' '; ++k) {
			v[i][j] = tmp[k];
			++j;
		}
		v[i][j] = '\0';
		j = 0;
		for (k = k + 1; tmp[k] != '\n'; ++k) {
			tmpint[j] = tmp[k];
			++j;
		}
		tmpint[j] = '\0';
		w[i] = atoi(tmpint);
	}
	size = i;
	for (i = 0; i < NUM * 2; ++i)
		p[i] = "";
	d = 0;
	for (i = 0; i < size; ++i) {
		for (j = 0; j < NUM; ++j)
			if (strcmp(p[j], u[i]) == 0)
				break;
		if (j >= NUM) {
			p[d] = u[i];
			++d;
		}
	}
	for (i = 0; i < size; ++i) {
		for (j = 0; j < NUM; ++j)
			if (strcmp(p[j], v[i]) == 0)
				break;
		if (j >= NUM) {
			p[d] = v[i];
			++d;
		}
	}
	for (i = 0; i < size; ++i) {
		for (j = 0; j < d; ++j)
			if (strcmp(p[j], u[i]) == 0)
				break;
		for (k = 0; k < d; ++k)
			if (strcmp(p[k], v[i]) == 0)
				break;
		m[j][k] = w[i];
		m[k][j] = w[i];
	}
	for (i = 0; i < NUM * 2; ++i)
		for (j = 0; j < NUM * 2; ++j)
			if (m[i][j] <= 0)
				m[i][j]	= INF;
	printf("Where are you currently located?\n");
	fgets(st, LEN, stdin);
	printf("Where do you want to go?\n");
	fgets(fn, LEN, stdin);
	for (i = 0; st[i] != '\n'; ++i);
	st[i] = '\0';
	for (i = 0; fn[i] != '\n'; ++i);
	fn[i] = '\0';
	data = dijkstra(d, st, fn, p, m);
	for (i = 0; i < d; ++i)
		if (strcmp(p[i], fn) == 0)
			break;
	for (j = 0; i != -1; ++j) {
		path[j] = p[i];
		i = data[i];
	}
	printf("The best route to your destination is:\n");
	for (i = j - 1; i >= 0; --i)
		printf("%s\n", path[i]);
	printf("Total distance: %d mi\n", data[d]);
}

int *dijkstra(int d, char *st, char *fn, char **p, int (*m)[NUM * 2])
{
	int parent[NUM], dist[NUM], set[NUM];
	int i, count, min, u, v;
	int *data;

	for (i = 0; i < d; ++i) {
		dist[i] = INF;
		set[i] = 0;
	}
	for (i = 0; i < d; ++i)
		if (strcmp(p[i], st) == 0)
			break;
	parent[i] = -1;
	dist[i] = 0;
	for (count = 0; count < d - 1; count++) {
		min = INF;
		for (v = 0; v < d; ++v) {
			if (set[v] == 0 && dist[v] <= min) {
				min = dist[v];
				u = v;
			}
		}
		set[u] = 1;
		for (v = 0; v < d; ++v) {
			if (!set[v] && m[u][v] && dist[u] != INF && dist[u] + m[u][v] < dist[v]) {
				parent[v] = u;
				dist[v] = dist[u] + m[u][v];
			}
		}
	}
	data = malloc((d + 1) * sizeof(int));
	for (i = 0; i < d; ++i)
		data[i] = parent[i];
	for (i = 0; i < d; ++i)
		if (strcmp(p[i], fn) == 0)
			break;
	data[d] = dist[i];
	return data;
}