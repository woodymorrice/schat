/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */


/* RttMonInit -- initializes the monitor
 * with the specified number of condition
 * variables */
int RttMonInit(int numConds) {
    /* return 0 on success, -1 on failure */
    return 0;
}


/* RttMonEnter -- signals to the server
 * that a process wishes to enter the
 * monitor */
int RttMonEnter() {
    /* return 0 on success, -1 on failure */
    return 0;
}


/* RttMonLeave -- signals to the server
 * that a process wishes to leave the
 * monitor */
int RttMonLeave() {
    /* return 0 on success, -1 on failure */
    return 0;
}


/* RttMonWait -- causes the calling
 * process to wait on some condition
 * variable (CV) */
int RttMonWait(int CV) {
    /* Calling process exits the monitor,
     * is added to the associated CV queue,
     * and waits until it is signalled by
     * another process */

    /* return 0 on success, -1 on failure */
    return 0;
}


/* RttMonSignal -- signals the process at
 * the head of the CV queue to resume */
int RttMonSignal(int CV) { 
    /* Calling process must exit the monitor,
     * is added to the urgent queue, and must
     * wait until the other process leaves the
     * monitor (ensures that only one process
     * is running in the monitor at a time) */
    

    /* return 0 on success, -1 on failure */
    return 0;
}


/* RttMonServer -- server PROCESS that handles
 * the coordination by putting processes on lists
 * according to the semantics of Monitors */
int RttMonServer() {
    /* Receives messages from the client
     * processes and determines which list they
     * are moved onto and off of and who to
     * reply to such that proper coordination
     * is achieved */

    /* return 0 on success, -1 on failure */
    return 0;
}
