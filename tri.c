#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

//./tri -f atrier.csv -o trié.csv 
main (int argc, char **argv)
{
  int aflag = 0;
  int bflag = 0;
  char *cvalue = NULL;
  int index;
  int c;

  opterr = 0;

  while ((c = getopt (argc, argv, "f:o:r")) != -1){
    switch (c){
      case 'f':
        fat=optarg;
        break;
      case 'o':
        fres=optarg;
        break;
      case 'r':
        cvalue = optarg;
        break;
      case '?':
        if (optopt == 'c')
          fprintf (stderr, "Option -%c requires an argument.\n", optopt);
        else if (isprint (optopt))
          fprintf (stderr, "Unknown option `-%c'.\n", optopt);
        else
          fprintf (stderr,"Unknown option character `\\x%x'.\n",optopt);
        return 1;
      default:
        abort ();
   }
}

