/* CMPT332 - Group 14
 * Phong Thanh Nguyen (David) - wdz468 - 11310824
 * Woody Morrice - wam553 - 11071060 */

/* Condition Variables */
/* CV #0 = OKtoRead
 * 0 if there are currently writers in CS
 * 1 if there are no writers in CS
 *
 * CV #1 = OKtoWrite
 * 0 if there are currently readers is CS
 * 1 if there are no readers in CS */

/* Lists */
/* enter queue -- threads waiting in MonEnter()
 * CV reader queue -- readers waiting with RttMonWait()
 * CV writers queue -- writers waiting with RttMonWait()
 * urgent queue -- threads waiting after calling
 * RttMonSignal, these threads always have top
 * priority to re-enter the monitor
 * CVlist -- list of conditions variables
 * data list -- data being read from and written
 * to */


/* - use RttSend() to communicate with server
 * - server manages queues and replies to messages */
    /* RttSend() to server process with
     * params: serverID, void* sendData,
     * u_int sendLength, void* recData */


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
    // messages sent:
    // 0 = reader wants to enter
    // 1 = writer wants to enter
    // send message to enter monitor
    // if caller is a reader:
    // can enter if other readers in monitor
    // added to enter queue if writer in monitor
    // if caller is a writer:
    // can enter if no threads in monitor
    // added to enter queue otherwise
    // all processes block in queue until
    // signal to enter is received

    /* return 0 on success, -1 on failure */
    return 0;
}


/* RttMonLeave -- signals to the server
 * that a process wishes to leave the
 * monitor */
int RttMonLeave() {
    // messages sent:
    // 0 = reader wants to exit
    // 1 = writer wants to exit
    // send message to leave monitor
    // so that monitor can signal the
    // next thread to enter

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
    // messages sent:
    // 0 = reader wants to wait
    // 1 = writer wants to wait
    // if reader enters the monitor and
    // there is no data to read, add
    // it to the reader CV queue
    // if writer enters the monitor and
    // there is no spaces left to write
    // data, add it to the writer queue

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
    // messages sent:
    // 0 = reader wants to signal
    // 1 = writer wants to signal
    // when a writer finishes writing it
    // calls this to allow a reader from the
    // CV queue to read the data it just wrote
    // (if there is any)
    // when all readers finish reading this is
    // called to allow a writer from the CV queue
    // to write (if there is any)

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
    // waits for messages with RttReceive()
    // processes messages in the order they
    // are received

    /* return 0 on success, -1 on failure */
    return 0;
}
