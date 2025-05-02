from flask import Flask,render_template,request,session,redirect,url_for,flash
from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin
from werkzeug.security import generate_password_hash,check_password_hash
from flask_login import login_user,logout_user,login_manager,LoginManager
from flask_login import login_required,current_user
import os
import pymysql
from dotenv import load_dotenv

# Load environment variables from .env
load_dotenv()

# Get database credentials from environment variables
AIVEN_USER = os.getenv("AIVEN_USER")
AIVEN_PASSWORD = os.getenv("AIVEN_PASSWORD")
AIVEN_HOST = os.getenv("AIVEN_HOST")
AIVEN_PORT = os.getenv("AIVEN_PORT")
AIVEN_DB = os.getenv("AIVEN_DB")

# Ensure all required credentials are loaded
if not all([AIVEN_USER, AIVEN_PASSWORD, AIVEN_HOST, AIVEN_PORT, AIVEN_DB]):
    raise ValueError("❌ Missing one or more database credentials in .env file.")

# MY db connection
local_server= True
app = Flask(__name__)
app.secret_key = os.getenv("SECRET_KEY")

# Ensure it's loaded correctly
if not app.secret_key:
    raise ValueError("❌ SECRET_KEY is missing in the .env file.")



# this is for getting unique user access
login_manager=LoginManager(app)
login_manager.login_view='login'

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

# SQLAlchemy Database URI using environment variables
app.config[
    "SQLALCHEMY_DATABASE_URI"
] = f"mysql+pymysql://{AIVEN_USER}:{AIVEN_PASSWORD}@{AIVEN_HOST}:{AIVEN_PORT}/{AIVEN_DB}"

# SSL Configuration for Aiven Cloud MySQL
app.config["SQLALCHEMY_ENGINE_OPTIONS"] = {
    "connect_args": {
        "ssl": {
            "ssl-mode": "REQUIRED"
        }
    }
}

db=SQLAlchemy(app)

# here we will create db models that is tables
class Test(db.Model):
    id=db.Column(db.Integer,primary_key=True)
    name=db.Column(db.String(100))

class Farming(db.Model):
    fid=db.Column(db.Integer,primary_key=True)
    farmingtype=db.Column(db.String(100))


class Addagroproducts(db.Model):
    username=db.Column(db.String(50))
    email=db.Column(db.String(50))
    pid=db.Column(db.Integer,primary_key=True)
    productname=db.Column(db.String(100))
    productdesc=db.Column(db.String(300))
    price=db.Column(db.Integer)
    stock = db.Column(db.Integer, nullable=False) 
    location = db.Column(db.String, nullable = False)
    farmingtype = db.Column(db.String(50), nullable=False)



class Trig(db.Model):
    id=db.Column(db.Integer,primary_key=True)
    fid=db.Column(db.String(100))
    action=db.Column(db.String(100))
    timestamp=db.Column(db.String(100))


class User(UserMixin,db.Model):
    id=db.Column(db.Integer,primary_key=True)
    username=db.Column(db.String(50))
    email=db.Column(db.String(50),unique=True)
    password=db.Column(db.String(1000))
    role = db.Column(db.String(20), nullable=False)

class Register(db.Model):
    rid=db.Column(db.Integer,primary_key=True)
    farmername=db.Column(db.String(50))
    email = db.Column(db.String(120), unique=True, nullable=False)
    adharnumber=db.Column(db.String(50))
    age=db.Column(db.Integer)
    gender=db.Column(db.String(50))
    phonenumber=db.Column(db.String(50))
    address=db.Column(db.String(50))
    farming=db.Column(db.String(50))

    

@app.route('/')
def index(): 
    return render_template('index.html')

@app.route('/farmerdetails')
@login_required
def farmerdetails():
    # query=db.engine.execute(f"SELECT * FROM `register`") 
    query=Register.query.all()
    return render_template('farmerdetails.html',query=query)

@app.route('/agroproducts')
def agroproducts():
    search_query = request.args.get('search', '')
    location_filter = request.args.get('location', '')
    farmingtype_filter = request.args.get('farmingtype', '')

    # Start with base query
    query = Addagroproducts.query

    # Apply filters if provided
    if search_query:
        query = query.filter(Addagroproducts.productname.ilike(f"%{search_query}%"))
    if location_filter:
        query = query.filter(Addagroproducts.location == location_filter)
    if farmingtype_filter:
        query = query.filter(Addagroproducts.farmingtype == farmingtype_filter)

    # Fetch the final results
    query = query.all()

    # Get unique locations and farming types for dropdown options
    unique_locations = db.session.query(Addagroproducts.location).distinct().all()
    unique_farmingtypes = db.session.query(Addagroproducts.farmingtype).distinct().all()

    # Convert tuples to simple lists
    unique_locations = [loc[0] for loc in unique_locations]
    unique_farmingtypes = [farm[0] for farm in unique_farmingtypes]

    return render_template('agroproducts.html', query=query, unique_locations=unique_locations, unique_farmingtypes=unique_farmingtypes)

@app.route('/addagroproduct',methods=['POST','GET'])
@login_required
def addagroproduct():
    if request.method=="POST":
        username=request.form.get('username')
        email=request.form.get('email')
        productname=request.form.get('productname')
        productdesc=request.form.get('productdesc')
        price=request.form.get('price')
        stock=request.form.get('stock')
        location = request.form.get('location')
        farmingtype = request.form.get('farmingtype')
        products=Addagroproducts(username=username,email=email,productname=productname,productdesc=productdesc,price=price,stock=stock,location=location,farmingtype=farmingtype)
        db.session.add(products)
        db.session.commit()
        flash("Product Added","info")
        return redirect('/dashboard')
   
    return render_template('addagroproducts.html')

@app.route('/triggers')
@login_required
def triggers():
    # query=db.engine.execute(f"SELECT * FROM `trig`") 
    query=Trig.query.all()
    return render_template('triggers.html',query=query)

@app.route('/addfarming',methods=['POST','GET'])
@login_required
def addfarming():
    if request.method=="POST":
        farmingtype=request.form.get('farming')
        query=Farming.query.filter_by(farmingtype=farmingtype).first()
        if query:
            flash("Farming Type Already Exist","warning")
            return redirect('/addfarming')
        dep=Farming(farmingtype=farmingtype)
        db.session.add(dep)
        db.session.commit()
        flash("Farming Addes","success")
    return render_template('farming.html')




@app.route("/delete/<string:rid>",methods=['POST','GET'])
@login_required
def delete(rid):
    # db.engine.execute(f"DELETE FROM `register` WHERE `register`.`rid`={rid}")
    post=Register.query.filter_by(rid=rid).first()
    db.session.delete(post)
    db.session.commit()
    flash("Slot Deleted Successful","warning")
    return redirect('/farmerdetails')


@app.route("/edit/<string:rid>",methods=['POST','GET'])
@login_required
def edit(rid):
    # farming=db.engine.execute("SELECT * FROM `farming`") 
    if request.method=="POST":
        farmername=request.form.get('farmername')
        adharnumber=request.form.get('adharnumber')
        age=request.form.get('age')
        gender=request.form.get('gender')
        phonenumber=request.form.get('phonenumber')
        address=request.form.get('address')
        farmingtype=request.form.get('farmingtype')     
        # query=db.engine.execute(f"UPDATE `register` SET `farmername`='{farmername}',`adharnumber`='{adharnumber}',`age`='{age}',`gender`='{gender}',`phonenumber`='{phonenumber}',`address`='{address}',`farming`='{farmingtype}'")
        post=Register.query.filter_by(rid=rid).first()
        print(post.farmername)
        post.farmername=farmername
        post.adharnumber=adharnumber
        post.age=age
        post.gender=gender
        post.phonenumber=phonenumber
        post.address=address
        post.farming=farmingtype
        db.session.commit()
        flash("Slot is Updates","success")
        return redirect('/farmerdetails')
    posts=Register.query.filter_by(rid=rid).first()
    farming=Farming.query.all()
    return render_template('edit.html',posts=posts,farming=farming)


@app.route('/signup',methods=['POST','GET'])
def signup():
    if request.method == "POST":
        username=request.form.get('username')
        email=request.form.get('email')
        password=request.form.get('password')
        role = request.form.get('role')
        print(username,email,password)
        user=User.query.filter_by(email=email).first()
        if user:
            flash("Email Already Exist","warning")
            return render_template('/signup.html')
        encpassword=generate_password_hash(password)

        # new_user=db.engine.execute(f"INSERT INTO `user` (`username`,`email`,`password`) VALUES ('{username}','{email}','{encpassword}')")

        # this is method 2 to save data in db
        newuser=User(username=username,email=email,password=encpassword,role=role)
        db.session.add(newuser)
        db.session.commit()
        flash("Signup Succes Please Login","success")
        return render_template('login.html')

          

    return render_template('signup.html')

@app.route('/login', methods=['POST', 'GET'])
def login():
    if request.method == "POST":
        email = request.form.get('email')
        password = request.form.get('password')
        selected_role = request.form.get('role')  # Role selected during login

        user = User.query.filter_by(email=email).first()

        if user and check_password_hash(user.password, password):
            if user.role != selected_role:  # Ensure selected role matches stored role
                flash("Incorrect role selected. Please choose the correct role.", "danger")
                return redirect(url_for('login'))

            login_user(user)
            session['role'] = user.role  # Store role in session

            flash("Login Success", "primary")
            return redirect(url_for('dashboard'))  # Redirect all users to the same dashboard

        else:
            flash("Invalid credentials", "warning")
            return render_template('login.html')

    return render_template('login.html')


@app.route('/logout')
@login_required
def logout():
    logout_user()
    flash("Logout SuccessFul","warning")
    return redirect(url_for('login'))



@app.route('/register',methods=['POST','GET'])
@login_required
def register():
    farming=Farming.query.all()

    # Check if the current user is already registered
    existing_registration = Register.query.filter_by(email=current_user.email).first()

    if existing_registration:
        flash("You have already registered your details.", "info")
        return redirect(url_for('dashboard'))  # Redirect to dashboard or another page
    

    if request.method=="POST":
        farmername=request.form.get('farmername')
        email = request.form.get('email')  # Get email from the form
        adharnumber=request.form.get('adharnumber')
        age=request.form.get('age')
        gender=request.form.get('gender')
        phonenumber=request.form.get('phonenumber')
        address=request.form.get('address')
        farmingtype=request.form.get('farmingtype')     
        query=Register(farmername=farmername,email = email,adharnumber=adharnumber,age=age,gender=gender,phonenumber=phonenumber,address=address,farming=farmingtype)
        db.session.add(query)
        db.session.commit()
        # query=db.engine.execute(f"INSERT INTO `register` (`farmername`,`adharnumber`,`age`,`gender`,`phonenumber`,`address`,`farming`) VALUES ('{farmername}','{adharnumber}','{age}','{gender}','{phonenumber}','{address}','{farmingtype}')")
        # flash("Your Record Has Been Saved","success")
        return redirect('/farmerdetails')
    return render_template('farmer.html',farming=farming)

@app.route('/dashboard')
@login_required
def dashboard():
    return render_template('base.html')

@app.route('/test-db')
def test_db():
    try:
        connection = pymysql.connect(
            host= AIVEN_HOST,
            user= AIVEN_USER,
            password= AIVEN_PASSWORD,
            database=AIVEN_DB
        )
        return "✅ Database connected successfully!"

    except pymysql.MySQLError as e:
        return f"❌ Error: {e}"

    finally:
        if 'connection' in locals():
            connection.close()



if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)
