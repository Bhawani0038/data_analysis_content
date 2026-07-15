import mysql.connector
conn = mysql.connector.connect( host = "localhost" , user = "root", password = "1234", database = "bank_db")
cursor = conn.cursor()

class Bank:
    def __init__(self):
        print("bank management app.....")
        print("connnecting to the server ......")

        self.home()

    def register(self):
        print('registration panel.......')
        name = input("name: ")
        email = input("email: ")
        password = input("password: ")
        self.save_registration_info_to_server(name, email,  password)

    def save_registration_info_to_server(self, name, email, password):
        query = "insert into user (name, email, password) values (%s, %s, %s);"
        cursor.execute( query,  (name, email, password))
        conn.commit()

        cursor.execute( "select * from user where name = %s and email = %s and password = %s; ", (name, email, password))

        user_data = cursor.fetchone()
        print("acccount no" , user_data[0], "name" , user_data[1])
        print("registration succesfull....")

    def dashboard(self):
        print("dashboard portal.....")
        while True:
            choice = input("""
                    1:  Check Balance
                    2:  Withdraw
                    3:  Deposit
                    4:  Update Password
                    5:  Exit""")

            if choice == "1":
                print("balance = ", self.check_balance())

            elif choice == "2":
                self.withdraw()
                    
            elif choice == "3":
                self.deposit()

            elif choice == "4":
                self.update_password()

            elif choice == "5":
                exit()

            else:
                print("invalid choice try again......")

    def check_balance(self):
        cursor.execute("select balance from user where email = %s and password = %s", (self.email, self.password))
        current_balance = cursor.fetchone()[0]
        return current_balance

    def withdraw(self):
        print("withdraw balance....")
        try:
            amount = float(input("amount to withdraw:  "))

            if amount > self.check_balance():
                print("insufficeint balance in your account .....")

            elif amount <= 0 :
                print("nregative amount error....")

            else:
                cursor.execute("update user set balance = balance - %s where email = %s and password = %s", (amount, self.email, self.password))
                conn.commit()
                print("amount {amount} witdhrawn sucessfully...")
                print("current balance = ", self.check_balance())
        except:
            print("invalid amount to withdraw......")

    def deposit(self):
        print("deposit balance....")

        try:
            amount = float(input("amoun to deposit...."))

            if amount <= 0:
                print("negative amount can't be deposited ....")
            
            else:
                cursor.execute("update user set balance = balance + %s where email = %s and password = %s", (amount, self.email, self.password))
                conn.commit()
                print("amount deposited sucessfully...")
                print("current balance = ", self.check_balance())
        
        except:
            print("invalid amount to deposit try again....")

    def update_password(self):
        print("password update....")
        self.new_password = input("new password:")
        cursor.execute("update user set password = %s where email = %s and password = %s", (self.new_password, self.email, self.password))
        conn.commit()
        print("pasword updated sucessfully... new password = ", self.check_password())

    def check_password(self):
        cursor.execute("select password from user where email = %s and password = %s", (self.email, self.new_password))
        return cursor.fetchone()[0]

    def login(self):
        print("login ......")
        self.email = input("Email:   ")
        self.password = input("Password: ")

        cursor.execute( "select * from user where email = %s and password = %s" , (self.email, self.password))
        user_data = cursor.fetchone()

        if not user_data:
            print("email or password is wrong .....")       
        else:
            self.dashboard()

    def home(self):
        print(".....home panel...")
        while True:
            choice = input("""
                1 : Register
                2 : Login
                3 : Exit
            """)

            if choice == "1":
                self.register()

            elif choice == "2":
                self.login()
            
            elif choice == "3":
                exit()
            else:
                print("invalid input try again.....")


def main():
    Bank()


if __name__ == '__main__':
    main()
