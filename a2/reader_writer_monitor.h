/* reader-writer.h
 * Dwight Makaroff October 27, 2011
 * necessary because I split up the 2 source files
 * for the reader-writer problem */

/* List Library provided with consent by
 * Joseph Medernach, imy309, 11313955
 * John Miller, knp254, 11323966 */

#include <list.h>

void Initialize(void);
void StartRead(void);
void StopRead(void);
void StartWrite(void);
void StopWrite(void);

