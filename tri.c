#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

//Bibliothèque de fonctions pour manipuler les tableaux
//TODO
//Bibliothèque de fonctions pour manipuler les ABR !incomplète!

typedef struct A{
	int elt;
	struct A * fg;
	struct A * fd;
}ABR;

ABR * creerABR(int e){
	ABR * noeud = malloc(sizeof(ABR));
	if(noeud==NULL){
		printf("Impossible de creer l'arbre");
		exit(1);
	}
	else{
		noeud->elt = e;
		noeud->fg = NULL;
		noeud->fd = NULL;
	}
	return noeud;
}



//Bibliothèque de fonctions pour manipuler les AVL

typedef struct A{
	int elt;
	struct A * fg;
	struct A * fd;
	int equilibre;
}AVL;

AVL * creerAVL(int e){
	AVL * noeud = malloc(sizeof(AVL));
	if(noeud==NULL){
		printf("Impossible de creer l'arbre");
		exit(1);
	}
	else{
		noeud->elt = e;
		noeud->fg = NULL;
		noeud->fd = NULL;
		noeud->equilibre = 0;
	}
	return noeud;
}

int max(int a,int b){
	if(a>b){
		return(a);
	}
	else{
		return(b);
	}
}

int min(int a,int b){
	if(a<b){
		return(a);
	}
	else{
		return(b);
	}
}

AVL * rotationGauche(AVL * a){
	AVL * pivot;
	int eq_a;
	int eq_p;

	pivot = a->fd;
	a->fd = pivot->fg;
	pivot->fg = a;
	eq_a = a->equilibre;
	eq_p = pivot->equilibre;
	a->equilibre = eq_a - max(eq_p , 0)-1;
	pivot->equilibre = min(min(eq_a-2, eq_a+eq_p-2),eq_p-1);
	a = pivot;
	return(a);

}

AVL * rotationDroite(AVL * a){
	AVL * pivot;
	int eq_a;
	int eq_p;

	pivot = a->fg;
	a->fg = pivot->fd;
	pivot->fd = a;
	eq_a = a->equilibre;
	eq_p = pivot->equilibre;
	a->equilibre = eq_a - min(eq_p , 0)+1;
	pivot->equilibre = max(max(eq_a+2, eq_a+eq_p+2),eq_p+1);
	a = pivot;
	return(a);

}

AVL * doubleRotationGauche(AVL * a){
	a->fd = rotationDroite(a->fd);
	return(rotationGauche(a));
}

AVL * doubleRotationDroite(AVL * a){
	a->fg = rotationGauche(a->fg);
	return(rotationDroite(a));
}

AVL * equilibreAVL(AVL * a){
	if(a->equilibre == 2){
		if(a->fd->equilibre >= 0){
			return(rotationGauche(a));
		}
		else{
			return(doubleRotationGauche(a));
		}
	}
	else if(a->equilibre == -2){
		if(a->fg->equilibre <= 0){
			return(rotationDroite(a));
		}
		else{
			return(doubleRotationDroite(a));
		}
	}
	return(a);
}

AVL * insertionAVL(AVL * a,int e,int * h){
	if(a == NULL){
		*h=1;
		return(creerArbre(e));
	}
	if(e < a->elt){
		a->fg = insertionAVL(a->fg,e,h);
		*h = -*h;
	}
	else if( e > a->elt){
		a->fd = insertionAVL(a->fd,e,h);
	}
	else{
		*h=0;
		return(a);
	}

	if(*h != 0){
		a->equilibre = a->equilibre + *h;
        a = equilibreAVL(a);
		if(a->equilibre == 0){
			*h=0;
		}
		else{
			*h=1;
		}
	}
	return(a);
}


//Fonctions de tri avec AVL ordre croissant/decroissant 
int tri_avl(FILE fichier_dep, FILE fichier_sort,int ordre){
  char ligne[100];
  int nb;
  int* h;
  //création avl -> tri des valeurs
  AVL* arbretri = creerAVL(NULL);
  while (fgets( ligne, 100, fichier_dep) != NULL){
    nb=atoi(ligne);
    insertionAVL(arbretri,nb,h);
  }
  //lecture de l'avl + renvoie des valeurs triées dans le fichier sortant
  //TODO
  if(ordre = 0){
    //ordre croissant
  }
  else{
    //ordre decroissant
  }
}


main (int argc, char *argv[]){
  //modification des arguments pour les verifier par la suite
  for(int i=0;i<=argc;i++){
    if(argv[i] == "-abr"){
      argv[i] = "1"
    }
    if(argv[i] == "-avl"){
      argv[i] = "2"
    }
    if(argv[i] == "-tab"){
      argv[i] = "3"
    }
  }
  int rverif = 0;
  char *fat = NULL;
  char *fres = NULL;
  int mtri = 1;
  int index;
  int c;
  //verification des arguments saisis par l'utilisateur
  opterr = 0;
  while ((c = getopt (argc, argv, "f:o:r123")) != -1){
    switch (c){
      case 'f':
        fat=optarg;
        break;
      case 'o':
        fres=optarg;
        break;
      case 'r':
        rverif = 1;
        break;
      case '1' :
        mtri = 1;
        break;
      case '2' :
        mtri = 2;
        break;
      case '3' :
        mtri = 3;
        break;
      case '?':
        if (optopt == 'f' || optopt == 'o'){
          fprintf (stderr, "Option -%c requière un argument.\n", optopt);
        }
        else if (isprint (optopt)){
          fprintf (stderr, "option inconnu `-%c'.\n", optopt);
        }
        else{
          fprintf (stderr,"caractères de l'option inconnu `\\x%x'.\n",optopt);
        }
        return 1;
      default:
        abort ();
    }
  }
  //Manipulation des fichiers d'entré et de sortie
  FILE* fichier_dep = NULL;
  FILE* fichier_res = NULL;
  fichier_dep = fopen(fat, "r+");
  fichier_res = fopen(fres, "w+");
  int processus=0;
  if (fichier_dep == NULL){
    return 2;
  }
  if (fichier_res == NULL){
    return 3;
  }
  if(mtri == 2){
    processus = tri_avl(fichier_dep,fichier_res,rverif);
  }
  int fermeture = 0;
  fermeture = fclose(fichier_dep);
  if(fermeture!=0){
    return 2;
  }
  fermeture = fclose(fichier_res);
  if(fermeture!=0){
    return 3;
  }
  return processus;
}
