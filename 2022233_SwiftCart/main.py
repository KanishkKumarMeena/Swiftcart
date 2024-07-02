from flask import Flask, render_template, request, redirect, url_for, flash, session, jsonify
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import CheckConstraint, desc,func
from sqlalchemy.exc import IntegrityError
from datetime import datetime

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:kvaf2jdh@localhost/swiftcart'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = 'your_secret_key'  # Required for flash messages
db = SQLAlchemy(app)
ADMIN_USERNAME = 'swiftcart'
ADMIN_PASSWORD = '1234'

# Define your database models here
class Customer(db.Model):
    __tablename__ = 'Customer'
    Customer_ID = db.Column(db.String(10), primary_key=True)
    Cus_Password = db.Column(db.String(6), nullable=False)
    First_Name = db.Column(db.String(15), nullable=False)
    Middle_Name = db.Column(db.String(15))
    Last_Name = db.Column(db.String(15))
    Email = db.Column(db.String(30), unique=True, nullable=False)
    Address = db.Column(db.String(255), nullable=False)
    Age = db.Column(db.Integer, nullable=False)

    __table_args__ = (
        CheckConstraint('Age >= 18', name='check_age'),
    )

    def __init__(self, Customer_ID, Cus_Password, First_Name, Middle_Name, Last_Name, Email, Address, Age):
        self.Customer_ID = Customer_ID
        self.Cus_Password = Cus_Password
        self.First_Name = First_Name
        self.Middle_Name = Middle_Name
        self.Last_Name = Last_Name
        self.Email = Email
        self.Address = Address
        self.Age = Age
class Supplier(db.Model):
    __tablename__ = 'Supplier'
    Supplier_ID = db.Column(db.String(10), primary_key=True)
    Store_ID = db.Column(db.String(10), nullable=False)
    Sup_Password = db.Column(db.String(6), nullable=False)
    First_Name = db.Column(db.String(15), nullable=False)
    Middle_Name = db.Column(db.String(15))
    Last_Name = db.Column(db.String(15))
    Email = db.Column(db.String(30), unique=True, nullable=False)

    def __init__(self, Supplier_ID, Store_ID, Sup_Password, First_Name, Middle_Name, Last_Name, Email):
        self.Supplier_ID = Supplier_ID
        self.Store_ID = Store_ID
        self.Sup_Password = Sup_Password
        self.First_Name = First_Name
        self.Middle_Name = Middle_Name
        self.Last_Name = Last_Name
        self.Email = Email

class Orders(db.Model):
    __tablename__ = 'Orders'
    Order_ID = db.Column(db.Integer, primary_key=True, autoincrement=True)
    Cart_ID = db.Column(db.Integer, db.ForeignKey('Cart.Cart_ID'), nullable=False)
    Order_Date = db.Column(db.DateTime, nullable=False, default=datetime.now())

    def __init__(self, Cart_ID, Order_Date):
        self.Cart_ID = Cart_ID
        self.Order_Date = Order_Date


class Item(db.Model):
    __tablename__ = 'Item'
    Item_ID = db.Column(db.String(10), primary_key=True)
    Item_Name = db.Column(db.String(30), nullable=False)
    Item_Quantity = db.Column(db.Integer, nullable=False)
    Price = db.Column(db.Integer, nullable=False)
    Image_Address = db.Column(db.String(30), nullable=False)
    I_Description = db.Column(db.String(224), nullable=False)  # Add the new column

    def __init__(self, Item_ID, Item_Name, Item_Quantity, Price, Image_Address, I_Description):
        self.Item_ID = Item_ID
        self.Item_Name = Item_Name
        self.Item_Quantity = Item_Quantity
        self.Price = Price
        self.Image_Address = Image_Address
        self.I_Description = I_Description  # Update to match the column name in your database

class ItemList(db.Model):
    __tablename__ = 'Item_List'
    Item_List_ID = db.Column(db.Integer, primary_key=True, autoincrement=True)
    Item_ID = db.Column(db.String(10), db.ForeignKey('Item.Item_ID'), nullable=False)
    Item_Quantity = db.Column(db.Integer, nullable=True)
    Item_Total_Price = db.Column(db.Integer, nullable=False)

class Cart(db.Model):
    __tablename__ = 'Cart'
    Cart_ID = db.Column(db.Integer, primary_key=True)
    Customer_ID = db.Column(db.String(10), db.ForeignKey('Customer.Customer_ID'), nullable=False)
    Item_List_ID = db.Column(db.Integer, db.ForeignKey('Item_List.Item_List_ID'), nullable=False)
    Cart_Price = db.Column(db.Integer, nullable=False)
class Supplies(db.Model):
    __tablename__ = 'Supplies'
    Item_ID = db.Column(db.String(10), db.ForeignKey('Item.Item_ID'), primary_key=True)
    Supplier_ID = db.Column(db.String(10), db.ForeignKey('Supplier.Supplier_ID'), primary_key=True)
    Item_Quantity = db.Column(db.Integer, nullable=False)

    # Define relationships
    item = db.relationship('Item', backref=db.backref('suppliers', cascade='all, delete-orphan'))
    supplier = db.relationship('Supplier', backref=db.backref('supplied_items', cascade='all, delete-orphan'))

    def __init__(self, Item_ID, Supplier_ID, Item_Quantity):
        self.Item_ID = Item_ID
        self.Supplier_ID = Supplier_ID
        self.Item_Quantity = Item_Quantity

@app.route('/admin_login', methods=['GET', 'POST'])
def admin_login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        if username == ADMIN_USERNAME and password == ADMIN_PASSWORD:
            session['admin_logged_in'] = True
            return redirect(url_for('admin'))
        else:
            flash('Incorrect admin username or password.', 'error')
    return render_template('admin_login.html')

@app.route('/')
def ls():
    return render_template('index.html')  # Renders the template with login/signup options

def order_items(item_name, quantity, customer_id, cart_id):
    try:
        item = Item.query.filter_by(Item_Name=item_name).first()
        if item and item.Item_Quantity >= quantity:
            total_price = item.Price * quantity
            item_list = ItemList(Item_ID=item.Item_ID, Item_Quantity=quantity, Item_Total_Price=total_price)
            db.session.add(item_list)
            db.session.commit()
            cart = Cart(Cart_ID=cart_id, Customer_ID=customer_id, Item_List_ID=item_list.Item_List_ID, Cart_Price=total_price)
            db.session.add(cart)
            db.session.commit()
            item.Item_Quantity -= quantity
            db.session.commit()
            return "Item ordered successfully!"
        else:
            return "Item not available in sufficient quantity."
    except Exception as e:
        db.session.rollback()
        flash(f"Error ordering items: {str(e)}", 'error')
        return "Error ordering items!"

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        max_login_attempts = 3
        failed_attempts_key = f'failed_attempts_{email}'
        failed_attempts = session.get(failed_attempts_key, 0)
        if failed_attempts >= max_login_attempts:
            flash('You have exceeded the maximum number of login attempts. Please try again later or sign up.', 'error')
            return redirect(url_for('login'))
        user = Customer.query.filter_by(Email=email).first()
        if user:
            if user.Cus_Password == password:
                session['customer_id'] = user.Customer_ID
                session[failed_attempts_key] = 0
                flash('Login successful!', 'success')
                return redirect(url_for('home'))
            else:
                flash('Incorrect password. Please try again.', 'error')
                session[failed_attempts_key] = failed_attempts + 1
        else:
            flash('Email does not exist. Please enter a valid email address or sign up.', 'error')

    return render_template('login.html')

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        password = request.form['password']
        first_name = request.form['first_name']
        middle_name = request.form.get('middle_name') or None
        last_name = request.form.get('last_name') or None
        email = request.form['email']
        address = request.form['address']
        age = int(request.form['age'])
        if age < 18:
            flash('Age must be at least 18 years old.', 'error')
            return redirect(url_for('signup'))
        existing_email = Customer.query.filter_by(Email=email).first()
        if existing_email:
            flash('Email already exists. Please use a different email address.', 'error')
            return redirect(url_for('signup'))
        existing_password = Customer.query.filter_by(Cus_Password=password).first()
        if existing_password:
            flash('Password already exists. Please use a different password.', 'error')
            return redirect(url_for('signup'))
        last_customer = Customer.query.order_by(Customer.Customer_ID.desc()).first()
        if last_customer:
            last_customer_id = int(last_customer.Customer_ID[3:])
            new_customer_id = f'CUS{last_customer_id + 1:07}'
        else:
            new_customer_id = 'CUS0000001'
        new_customer = Customer(Customer_ID=new_customer_id, Cus_Password=password, First_Name=first_name,
                                Middle_Name=middle_name, Last_Name=last_name, Email=email, Address=address, Age=age)
        db.session.add(new_customer)
        try:
            db.session.commit()
            flash('Signup successful! Please login to continue.', 'success')
            return redirect(url_for('login'))
        except IntegrityError:
            db.session.rollback()
            flash('An error occurred. Please try again later.', 'error')
    return render_template('signup.html')

@app.route('/home', methods=['GET', 'POST'])
def home():
    if request.method == 'POST':
        customer_id = session.get('customer_id')
        if customer_id:
            item_list = []
            item_ids = request.form.getlist('item_id')
            quantities = request.form.getlist('quantity')
            cart_id = Cart.query.order_by(Cart.Cart_ID.desc()).first().Cart_ID + 1
            for item_id, quantity in zip(item_ids, quantities):
                item = Item.query.filter_by(Item_ID=item_id).first()
                if item:
                    print(f"{item.Item_Name}: {int(quantity)}")
                    if int(quantity) > 0:
                        item_list.append([item.Item_Name, int(quantity)])
                        order_items(item.Item_Name, int(quantity), customer_id, cart_id)
            print(item_list)
            return redirect(url_for('home'))
        else:
            flash('You need to login first.', 'error')
            return redirect(url_for('login'))
    items = Item.query.filter(Item.Item_Quantity > 0).all()
    return render_template('home.html', items=items)


@app.route('/cart')
def cart():
    last_cart_entry = Cart.query.order_by(desc(Cart.Cart_ID)).first()
    if last_cart_entry:
        items_in_cart = db.session.query(Item, ItemList.Item_Quantity, ItemList.Item_Total_Price)\
            .join(ItemList, ItemList.Item_ID == Item.Item_ID)\
            .join(Cart, Cart.Item_List_ID == ItemList.Item_List_ID)\
            .filter(Cart.Cart_ID == last_cart_entry.Cart_ID)\
            .all()
        total_price = db.session.query(func.sum(ItemList.Item_Total_Price))\
            .join(Cart, Cart.Item_List_ID == ItemList.Item_List_ID)\
            .filter(Cart.Cart_ID == last_cart_entry.Cart_ID)\
            .scalar()
        total_price = total_price or 0

        return render_template('cart.html', items_in_cart=items_in_cart, total_price=total_price)
    else:
        return render_template('cart.html', items_in_cart=None, total_price=0)

@app.route('/admin')
def admin():
    all_items = Item.query.all()
    all_customers = Customer.query.with_entities(Customer.Customer_ID, Customer.First_Name, Customer.Middle_Name, Customer.Last_Name, Customer.Email, Customer.Address, Customer.Age).all()
    all_orders = db.session.query(Orders, Cart).join(Cart).all()
    all_suppliers = Supplier.query.all()  # Query the Supplier table

    return render_template('dashboard.html', items=all_items, customers=all_customers, orders=all_orders, suppliers=all_suppliers)


@app.route('/order')
def order():
    last_cart_entry = Cart.query.order_by(desc(Cart.Cart_ID)).first()
    if last_cart_entry:
        new_order = Orders(Cart_ID=last_cart_entry.Cart_ID, Order_Date=datetime.now().strftime('%Y-%m-%d'))
        db.session.add(new_order)
        db.session.commit()
        delivery_info = db.session.query(Customer.Address).join(Cart).join(Orders).filter(Orders.Cart_ID == last_cart_entry.Cart_ID).first()
        if delivery_info:
            delivery_address = delivery_info.Address
        else:
            delivery_address = "Unknown"
        return render_template('order.html', delivery_address=delivery_address)
    else:
        flash('No items in the cart.', 'error')
        return redirect(url_for('cart'))

@app.route('/about')
def about():
    return render_template('about.html')


if __name__ == '__main__':
    app.run(debug=True)
