# AHMADREZA YAZDANI (9932095) OS-LAB PROJECT 2023


import threading
import time
import queue


# Defining the OS resources
cpu = 100 # percentage
ram = 6 # GB
bandwidth = 10 # Mbps

# Defining a lock for accessing the resources
lock = threading.Lock()

# Defining a list of processes
processes = []

# Defining a queue for scheduling processes
schedule = queue.Queue()

# Defining a function to check the processes
def check():
    if not processes:
        return print("There is no Process running")      
    else:
       for p in processes:
            print(f"{p.name} (PID: {p.ident}), CPU: {p.cpu}, Ram: {p.ram}, Bandwidth: {p.bandwidth}")
   
# Defining a function to manage the processes
def manage(pid, command):
    # Printing the process information
    print(f"Process manager (PID: {threading.current_thread().ident}) is running with command {command} on target PID {pid}")
    
    # Acquiring the lock
    lock.acquire()

    # Finding the target process by its ID
    target = None
    for p in processes:
        if p.ident == pid:
            target = p
            break

    # Checking if the target process exists
    if target is None:
        print(f"Process manager (PID: {threading.current_thread().ident}) could not find the target PID {pid}")
        lock.release()
        return
    global cpu
    global ram
    global bandwidth
    # Executing the command on the target process
    if command == "kill":
        # Terminating the target process and returning its resources to the OS
        processes.remove(target)
       # target.terminate()
        cpu += target.cpu
        ram += target.ram
        bandwidth += target.bandwidth
        # Printing the success message
        print(f"Process manager (PID: {threading.current_thread().ident}) killed the target PID {pid}")

 

# Defining a function to run VPN
def vpn():
    # Printing the process information
    print(f"Process VPN (PID: {threading.current_thread().ident}) is running")


# Defining a function to run Mine
def mine():
     # Printing the process information 
     print(f"Process Mine (PID: {threading.current_thread().ident}) is running")

     # Checking if VPN is running 
     vpn_running = False 
     for p in processes:
         if p.name == "VPN":
             vpn_running = True 
             break 

     # Printing a success message if VPN is running, or an error message otherwise 
     if vpn_running:
         time.sleep(30) # Sleeping for 30 seconds
         print(f"Process Mine (PID: {threading.current_thread().ident}) completed successfully")
     else:
         print(f"Process Mine (PID: {threading.current_thread().ident}) encountered a network error")

     # Acquiring the lock 
     lock.acquire()

     # Returning the resources to the OS and removing Mine from the list of processes 
     global cpu
     global ram
     global bandwidth
     cpu += 80 
     ram += 4 
     bandwidth += 8 
     processes.remove(threading.current_thread())

     # Checking if there are any processes waiting in the queue and running them if possible 
     while not schedule.empty():
         # Getting the next process from the queue 
         next_process = schedule.get()

         # Checking if there are enough resources for it 
         if cpu >= next_process[1] and ram >= next_process[2] and bandwidth >= next_process[3]:
             # Allocating resources to it and updating the OS resources 
             cpu -= next_process[1]
             ram -= next_process[2]
             bandwidth -= next_process[3]

             # Adding it to the list of processes and setting its attributes 
             processes.append(next_process[0])
             next_process[0].cpu = next_process[1]
             next_process[0].ram = next_process[2]
             next_process[0].bandwidth = next_process[3]

             # Starting it 
             next_process[0].start()

             # Printing a message 
             print(f"Process {next_process[0].name} (PID: {next_process[0].ident}) started from queue")

         else:
             # Putting it back to the queue and breaking the loop 
             schedule.put(next_process)
             break

     # Releasing the lock 
     lock.release()



# Defining a function to run Counter
def counter():
     global cpu
     global ram
     global bandwidth
     # Printing the process information 
     print(f"Process Counter (PID: {threading.current_thread().ident}) is running")
     # Counting up to 10,000 and printing the last number
     count = 0
     while count < 10000:
         count += 1
     
     print(f"Process Counter (PID: {threading.current_thread().ident}) counted up to {count}")
     # Acquiring the lock
     lock.acquire()
     # Returning the resources to the OS and removing Counter from the list of processes
     cpu += 10
     ram += 3

     processes.remove(threading.current_thread())
    # Checking if there are any processes waiting in the queue and running them if possible 
     while not schedule.empty():
        # Getting the next process from the queue 
        next_process = schedule.get()

        # Checking if there are enough resources for it 
        if cpu >= next_process[1] and ram >= next_process[2] and bandwidth >= next_process[3]:
            # Allocating resources to it and updating the OS resources 
            cpu -= next_process[1]
            ram -= next_process[2]
            bandwidth -= next_process[3]
            # Adding it to the list of processes and setting its attributes 
            processes.append(next_process[0])
            next_process[0].cpu = next_process[1]
            next_process[0].ram = next_process[2]
            next_process[0].bandwidth = next_process[3]
            # Starting it 
            next_process[0].start()
            # Printing a message 
            print(f"Process {next_process[0].name} (PID: {next_process[0].ident}) started from queue")
        else:
            # Putting it back to the queue and breaking the loop 
            schedule.put(next_process)
            break
    # Releasing the lock
     lock.release()

# Defining a function to update the screen with OS resources and process information
def update_screen():
    print(f"CPU: {cpu}%")
    print(f"Ram: {ram} GB")
    print(f"Bandwidth: {bandwidth} Mbps")
    print("Enter your choice:")
    print("1. print processes")
    print("2. Manage processes")
    print("3. Run a process")
    print("0. Exit")

def get_choice():
    while True:
        try:
            choice = int(input())
            if choice in [1, 2, 3 ,0]:
                return choice
            else:
                raise ValueError
        except ValueError:
            print("Invalid choice. Try again.")

# Defining a function to get user PID and validate it
def get_pid():
    while True:
        try:
            pid = int(input())
            if pid > 0:
                return pid
            else:
                raise ValueError
        except ValueError:
            print("Invalid PID. Try again.")

# Defining a function to get user command and validate it
def get_command():
    while True:
        command = input()
        if command == "kill":
            return command
        else:
            print("Invalid command. Try again.")

# Defining a function to get user process and validate it
def get_process():
    while True:
        process = input()
        if process in ["VPN", "Mine", "Counter"]:
            return process
        else:
            print("Invalid process. Try again.")

# Using a while loop to keep asking for user choice

def menu():
    global cpu
    global ram
    global bandwidth
    while True:
        # Updating the screen for the first time or after executing a user choice
        update_screen()
        # Getting the user choice and executing it
        choice = get_choice()
        if choice == 1:
            # Creating and starting a thread for check process
            t1 = threading.Thread(target=check, name="Check",args=()) 
            t1.start()

        elif choice == 2:
            # Getting the user PID and command
            print("Enter the target PID:")
            pid = get_pid()
            print("Enter the command:")
            command = get_command()
            # Creating and starting a thread for manage process
            t2 = threading.Thread(target=manage, args=(pid, command), name="Manager")
            t2.start()

        elif choice == 3:
            # Getting the user process
            print("Enter the process name:(VPN, Mine, Counter)")
            process = get_process()
            # Creating a thread for the chosen process but not starting it yet
            if process == "VPN":
                t3 = threading.Thread(target=vpn, name="VPN")            
            elif process == "Mine":
                t4 = threading.Thread(target=mine, name="Mine")
            elif process == "Counter":
                t5 = threading.Thread(target=counter, name="Counter")
            # Acquiring the lock 
            lock.acquire()

            # Trying to run the chosen process or putting it in the queue if not enough resources 
            if process == "VPN":
                if cpu >= 0 and ram >= 0 and bandwidth >= 2:
                    bandwidth -= 2
                    processes.append(t3)
                    t3.start()   
                    t3.cpu = 0 
                    t3.ram = 0 
                    t3.bandwidth = 2  
                else:
                    schedule.put((t3, 0, 0, 2))
            elif process == "Mine":
                if cpu >= 80 and ram >= 4 and bandwidth >= 8:
                    cpu -= 80 
                    ram -= 4 
                    bandwidth -= 8
                    processes.append(t4)
                    t4.start()
                    t4.cpu = 80 
                    t4.ram = 4 
                    t4.bandwidth = 8 
                else:
                    schedule.put((t4, 80, 4, 8))
            elif process == "Counter":
                if cpu >= 10 and ram >= 3 and bandwidth >= 0:
                    cpu -= 10 
                    ram -= 3
                    processes.append(t5)
                    t5.start()
                    t5.cpu = 10 
                    t5.ram = 3 
                    t5.bandwidth = 0 
                else:
                    schedule.put((t5,10,3,0))
            # Releasing the lock 
            lock.release()
        elif choice == 0:
            # Breaking the loop and exiting the program
            return

    # Joining the threads to wait for them to finish 
        if choice == 1:
            t1.join()
        elif choice == 2:
            t2.join()
        elif choice == 3:
            if process == "VPN":
                t3.join()
                
            elif process == "Mine":
                t4.join()
            elif process == "Counter":
                t5.join()
#start the program
menu()
# Printing a message when all threads are done or user exits
print("All processes are done or user exited")