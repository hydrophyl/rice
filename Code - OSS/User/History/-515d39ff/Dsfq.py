from flask import Flask, render_template, request, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
import requests
import os
from bs4 import BeautifulSoup
import wget

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///img.db'
db = SQLAlchemy(app)


class Img_link(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    img_link = db.Column(db.Text, nullable=False)

    def __repr__(self):
        return "Image nr. " + str(self.id)


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/input', methods=['GET', 'POST'])
def input():
    link = request.form['link']
    # new_Img_link = Img_link(img_link=link)
    # db.session.add(new_Img_link)
    # db.session.commit()
    response = requests.get(link)
    soup = BeautifulSoup(response.text, 'html.parser')
    img_tags = soup.find_all('a', class_='fileThumb')
    urls = [img['href'] for img in img_tags]
    list_of_images = []
    for url in urls:
        list_of_images.append(url)
        os.chdir(url_for('static/images'))
    for i in range(0, len(list_of_images)):
        print(list_of_images[i])
        wget.download('http://' + list_of_images[i])
    return render_template('input.html', link=link, urls=list_of_images)


@app.route('/gallery')
def dl():
    os.chdir(url_for('static/images'))
    files = os.listdir()
    return render_template('gallery.html', files=files)


@app.route('/gallery/empty')
def empty():
    os.chdir(url_for('static/images'))
    files = os.listdir()
    for file in files:
        os.remove(file)
    return redirect('/')


if __name__ == '__main__':
    app.run(debug=True)
