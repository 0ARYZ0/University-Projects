from tkinter import *
from tkinter import ttk
from tkinter.ttk import *
from PIL import Image, ImageTk
from main import fields , predict , defaults

EnTry = [None]

def popup(event):
    global e
    e = EnTry[0]
    print(event.x_root)
    try:
        menu.tk_popup(event.x_root,event.y_root) # Pop the menu up in the given coordinates
    finally:
        menu.grab_release() # Release it once an option is selected

def paste():
    try:
        clipboard = MainWindow.clipboard_get() # Get the copied item from system clipboard
        e.insert('end',clipboard) # Insert the item into the entry widget
    except :
        pass
def copy():
    try:
        if e.get():
            try:
                e.selection_get()
                inp = e.selection_get()
            except:
                inp = e.get()# Get the text inside entry widget
                
            MainWindow.clipboard_clear() # Clear the tkinter clipboard
            MainWindow.clipboard_append(inp) # Append to system clipboard
    except:
        pass
def cut():
    try:
        copy()
        try : e.delete(SEL_FIRST,SEL_LAST)
        except : e.delete(0,END)
    except:
        pass
    
def reset():
    e.delete(0,END)
    e.insert(0,defaults[fields[ens.index(e)]])
    
def cheekdiabet(data):
    return predict(data)
     
def senddata():
    awnsers = [en.get() for en in ens]
    if all(awnsers):
        result = cheekdiabet({fields[i]:float(awnsers[i]) for i in range(len(fields)) })


        if result:
            newWindow.title('شما ديابت داريد')
            Lresult.configure(text='شما ديابت داريد')
        else:
            newWindow.title('شما ديابت نداريد')
            Lresult.configure(text='شما ديابت نداريد')
    else :
            newWindow.title('خطا')
            Lresult.configure(text='لطفا ورودي ها را تکميل کنيد')
        
    newWindow.deiconify()

MainWindow = Tk()
MainWindow.resizable(False,False)
MainWindow.title("")
MainWindow.iconbitmap('icon.ico')
MainWindow.configure(background='white')

newWindow = Toplevel(MainWindow)
newWindow.withdraw()
newWindow.iconbitmap('icon.ico')
newWindow.attributes('-toolwindow', 1)
newWindow.configure(background = 'white')
newWindow.protocol("WM_DELETE_WINDOW", newWindow.withdraw)
Lresult = Label(newWindow,background = 'white')
Lresult.pack(padx=30,pady=30)



menu = Menu(MainWindow,tearoff=0) # Create a menu
menu.add_command(label='Copy',background='white',command=copy) # Create labels and commands
menu.add_command(label='Paste',background='white',command=paste)
menu.add_command(label='Cut',background='white',command=cut)
menu.add_command(label='Reset',background='white',command=reset)


defaults = {i : round(float(defaults[i]),2) for i in defaults}
ens = []

#fields = ['BMI','Glucose','2H','Diabets','goosfand']
for b,i in enumerate(fields):
    Label(MainWindow,background='white',text=i + ' : ').grid(row = b, column = 0, sticky = W,padx=5, pady = 5)
    en = Entry(MainWindow,width=20)
    en.grid(row = b, column = 1, sticky = W,padx=10, pady = 2)
    en.insert(0,defaults[i])
    ens.append(en)
    l = len(ens) - 1
    creator = lambda l : (lambda e : EnTry.__setitem__(0,ens[l]) or print(l) or popup(e))
    creator2 = lambda l,func : (lambda e : EnTry.__setitem__(0,ens[l]) or func())
    creator3 = lambda l,u : (lambda e : ens[l+1].focus() if l+1 < len(ens) else (senddata() if u else None))
    creator4 = lambda l : (lambda e : ens[l-1].focus() if l!=0 else None)


    en.bind('<Button-3>'  , creator(l)        )
    en.bind('<Control-c>' , creator2(l,copy)  )
    en.bind('<Control-v>' , creator2(l,paste) )
    en.bind('<Control-x>' , creator2(l,cut)   )
    en.bind('<Down>'      , creator3(l,0)     )
    en.bind('<Return>'    , creator3(l,1)     )
    en.bind('<Up>'        , creator4(l)       )


Button(MainWindow,text='تاييد',command = senddata).grid(row=b+1,column=1,pady=(15,15),sticky = 'w')

deleteicon = ImageTk.PhotoImage(Image.open('deleteicon.png').resize((35,40)))
Button(MainWindow,image=deleteicon,command = lambda : [en.delete(0,END) for en in ens]).grid(row=b+1,column=0,padx=(20,0),pady=(15,15),sticky = 'w')

resseticon = ImageTk.PhotoImage(Image.open('reset_icon.png').resize((35,40)))
Button(MainWindow,image=resseticon,command = lambda : [en.delete(0,END) for en in ens] and [en.insert(0,defaults[fields[k]]) for k,en in enumerate(ens)]).grid(row=b+1,column=1,padx=(90,0),pady=(15,15),sticky = 'w')


MainWindow.mainloop()