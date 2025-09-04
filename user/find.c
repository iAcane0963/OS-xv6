#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

// Get the base name from a path.
char*
fmtname(char *path)
{
  char *p;

  // Find the last slash in the path.
  for(p=path+strlen(path); p >= path && *p != '/'; p--);
  p++;
  return p;
}

// Recursively find a file with a given name in a directory.
void
find(char *path, char *target_name)
{
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  // Open the directory and check for errors.
  if((fd = open(path, 0)) < 0){
    fprintf(2, "find: cannot open %s\n", path);
    return;
  }

  // Get file status and check for errors.
  if(fstat(fd, &st) < 0){
    fprintf(2, "find: cannot stat %s\n", path);
    close(fd);
    return;
  }

  // Check if it's a directory.
  if(st.type == T_DIR){
    // Read directory entries.
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0)
        continue;

      // Do not recurse into '.' and '..'
      if(strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
        continue;

      // Construct the new path for the next level.
      strcpy(buf, path);
      p = buf+strlen(buf);
      *p++ = '/';
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;

      // Get status of the new path.
      if(stat(buf, &st) < 0){
        printf("find: cannot stat %s\n", buf);
        continue;
      }
      
      // If it's a directory, recurse.
      if(st.type == T_DIR){
        find(buf, target_name);
      } else if (st.type == T_FILE){
        // If it's a file, check if its name matches the target name.
        if(strcmp(fmtname(buf), target_name) == 0){
          printf("%s\n", buf);
        }
      }
    }
  }

  close(fd);
}

int
main(int argc, char *argv[])
{
  if(argc < 3){
    fprintf(2, "Usage: find <directory> <filename>\n");
    exit(1);
  }

  // Call the recursive find function with the provided arguments.
  find(argv[1], argv[2]);

  exit(0);
}