from flask import Flask, jsonify, request
import mysql.connector
from flask import request

app = Flask(__name__)

# MySQL database configuration
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': '',
    'database': 'pet_database',
}

# Function to create a MySQL connection and cursor
def get_db_cursor():
    db = mysql.connector.connect(**db_config)
    cursor = db.cursor()
    return db, cursor

# Example endpoint for fetching all users
@app.route('/api/users', methods=['GET'])
def get_users():
    db, cursor = None, None
    try:
        db, cursor = get_db_cursor()
        cursor.execute('SELECT * FROM users')
        results = cursor.fetchall()

        # Convert the results to a list of dictionaries
        users = [{'id': row[0], 'email': row[1], 'nickname': row[2], 'password': row[3],
                  'business_name': row[4], 'phone': row[5], 'address': row[6], 'account_type': row[7]} for row in results]

        return jsonify({'users': users})
    except Exception as e:
        print('Error fetching users:', e)
        return jsonify({'error': 'Internal Server Error'}), 500
    finally:
        if cursor:
            cursor.close()
        if db:
            db.close()


@app.route('/api/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    db, cursor = None, None
    try:
        db, cursor = get_db_cursor()
        cursor.execute('SELECT * FROM users WHERE id = %s', (user_id,))
        result = cursor.fetchone()

        if result:
            user_info = {
                'id': result[0],
                'email': result[1],
                'nickname': result[2],
                'password': result[3],
                'business_name': result[4],
                'phone': result[5],
                'address': result[6],
                'account_type': result[7]
            }
            return jsonify({'user': user_info})
        else:
            return jsonify({'error': 'User not found'}), 404
    except Exception as e:
        print('Error fetching user:', e)
        return jsonify({'error': 'Internal Server Error'}), 500
    finally:
        if cursor:
            cursor.close()
        if db:
            db.close()

@app.route('/api/users/<int:user_id>/posts', methods=['GET'])
def get_user_posts(user_id):
    db, cursor = None, None
    try:
        db, cursor = get_db_cursor()
        cursor.execute('SELECT * FROM posts WHERE user_id = %s', (user_id,))
        results = cursor.fetchall()

        posts = [
            {
                'id': row[0],
                'username': row[1],
                'image_path': row[2],
                'location': row[3],
                'user_id': row[4],
                'likes': row[5],
            }
            for row in results
        ]

        return jsonify({'posts': posts})
    except Exception as e:
        print('Error fetching user posts:', e)
        return jsonify({'error': 'Internal Server Error'}), 500
    finally:
        if cursor:
            cursor.close()
        if db:
            db.close()


@app.route('/api/users/<int:user_id>/friends', methods=['GET'])
def get_user_friends(user_id):
    db, cursor = None, None
    try:
        db, cursor = get_db_cursor()
        cursor.execute('SELECT user2_id FROM friendships WHERE user1_id = %s UNION SELECT user1_id FROM friendships WHERE user2_id = %s', (user_id, user_id))
        results = cursor.fetchall()

        friend_ids = [row[0] for row in results]

        return jsonify({'friend_ids': friend_ids})
    except Exception as e:
        print('Error fetching user friends:', e)
        return jsonify({'error': 'Internal Server Error'}), 500
    finally:
        if cursor:
            cursor.close()
        if db:
            db.close()
            
@app.route('/api/login', methods=['POST'])
def login():
    db, cursor = None, None
    try:
        db, cursor = get_db_cursor()

        data = request.get_json()
        email = data['email']
        password = data['password']

        # Check if the user with the given email and password exists
        cursor.execute('SELECT * FROM users WHERE email = %s AND password = %s', (email, password))
        result = cursor.fetchone()

        if result:
            user_id = result[0]  # Assume the first column is the user ID
            # User exists, return success with user ID
            return jsonify({'user_id': user_id, 'message': 'Login successful'})
        else:
            # User not found, return error
            return jsonify({'error': 'Invalid credentials'}), 401
    except Exception as e:
        print('Error during login:', e)
        return jsonify({'error': 'Internal Server Error'}), 500
    finally:
        if cursor:
            cursor.close()
        if db:
            db.close()

@app.route('/api/signup', methods=['POST'])
def signup():
    db, cursor = None, None
    try:
        db, cursor = get_db_cursor()

        data = request.get_json()
        email = data['email']
        nickname = data['nickname']
        password = data['password']
        account_type = data['account_type']
        business_name = data.get('business_name', None)
        phone = data.get('phone', None)
        address = data.get('address', None)

        # Insert new user into the database
        cursor.execute('INSERT INTO users (email, nickname, password, account_type, business_name, phone, address) VALUES (%s, %s, %s, %s, %s, %s, %s)',
                       (email, nickname, password, account_type, business_name, phone, address))

        db.commit()

        return jsonify({'message': 'User created successfully'})
    except Exception as e:
        print('Error creating user:', e)
        return jsonify({'error': 'Internal Server Error'}), 500
    finally:
        if cursor:
            cursor.close()
        if db:
            db.close()

@app.route('/api/posts', methods=['GET'])
def get_posts():
    db, cursor = None, None
    try:
        db, cursor = get_db_cursor()
        cursor.execute('SELECT * FROM posts')
        results = cursor.fetchall()

        # Convert the results to a list of dictionaries
        posts = [{'username': row[1], 'image_path': row[2], 'location': row[3], 'user_id': row[4], 'id': row[0], 'likes': row[5]} for row in results]

        return jsonify(posts)
    except Exception as e:
        print('Error fetching posts:', e)
        return jsonify({'error': 'Internal Server Error'}), 500
    finally:
        if cursor:
            cursor.close()
        if db:
            db.close()


@app.route('/api/post/<int:post_id>', methods=['GET'])
def get_post(post_id):
    db, cursor = None, None
    try:
        db, cursor = get_db_cursor()
        cursor.execute('SELECT * FROM posts WHERE id = %s', (post_id,))
        results = cursor.fetchall()

        # Convert the results to a list of dictionaries
        posts = [{'username': row[1], 'image_path': row[2], 'location': row[3], 'user_id': row[4], 'id': row[0], 'likes': row[5]} for row in results]

        return jsonify(posts)
    except Exception as e:
        print('Error fetching posts:', e)
        return jsonify({'error': 'Internal Server Error'}), 500
    finally:
        if cursor:
            cursor.close()
        if db:
            db.close()



@app.route('/api/comments/<int:post_id>', methods=['GET'])
def get_comments(post_id):
    db, cursor = None, None
    try:
        db, cursor = get_db_cursor()
        cursor.execute('SELECT * FROM comments WHERE post_id = %s', (post_id,))
        results = cursor.fetchall()

        # Convert the results to a list of dictionaries
        comments = [{'id': row[0], 'post_id': row[1], 'username': row[2], 'comment': row[3]} for row in results]

        return jsonify({'comments': comments})
    except Exception as e:
        print('Error fetching comments:', e)
        return jsonify({'error': 'Internal Server Error'}), 500
    finally:
        if cursor:
            cursor.close()
        if db:
            db.close()

# Example endpoint for creating a new comment for a specific post
@app.route('/api/comments/<int:post_id>', methods=['POST'])
def create_comment(post_id):
    db, cursor = None, None
    try:
        db, cursor = get_db_cursor()

        # Extract data from the request
        data = request.get_json()
        username = data.get('username')
        comment_text = data.get('comment')

        # Insert the new comment into the database
        cursor.execute(
            'INSERT INTO comments (post_id, username, comment) VALUES (%s, %s, %s)',
            (post_id, username, comment_text)
        )
        db.commit()

        return jsonify({'success': True}), 201  # HTTP 201 Created
    except Exception as e:
        print('Error creating comment:', e)
        return jsonify({'error': 'Internal Server Error'}), 500
    finally:
        if cursor:
            cursor.close()
        if db:
            db.close()


@app.route('/api/delete_friendships/<int:user1_id>/<int:user2_id>', methods=['DELETE'])
def delete_friendship(user1_id, user2_id):
    db, cursor = None, None
    try:
        db, cursor = get_db_cursor()
        
        # Delete the friendship where either user1_id is user1_id and user2_id is user2_id,
        # or vice versa to handle both directions
        cursor.execute('DELETE FROM friendships WHERE (user1_id = %s AND user2_id = %s) OR (user1_id = %s AND user2_id = %s)',
                       (user1_id, user2_id, user2_id, user1_id))

        db.commit()

        return '', 204  # No content, indicating success
    except Exception as e:
        print('Error deleting friendship:', e)
        return jsonify({'error': 'Internal Server Error'}), 500
    finally:
        if cursor:
            cursor.close()
        if db:
            db.close()


@app.route('/api/friendships/<int:user1_id>/<int:user2_id>', methods=['POST'])
def send_friend_request(user1_id, user2_id):
    db, cursor = None, None
    try:
        db, cursor = get_db_cursor()
        
        # Delete the friendship where either user1_id is user1_id and user2_id is user2_id,
        # or vice versa to handle both directions
        cursor.execute('INSERT INTO requests (user1_id, user2_id) VALUES(%s, %s)', (user1_id, user2_id))
        db.commit()

        return '', 204  # No content, indicating success
    except Exception as e:
        print('Error deleting friendship:', e)
        return jsonify({'error': 'Internal Server Error'}), 500
    finally:
        if cursor:
            cursor.close()
        if db:
            db.close()


@app.route('/api/users/<int:user_id>/friend-requests', methods=['GET'])
def get_friend_requests(user_id):
    db, cursor = None, None
    try:
        db, cursor = get_db_cursor()
        cursor.execute('SELECT user1_id FROM requests WHERE user2_id = %s', (user_id,))
        results = cursor.fetchall()

        users_ids = [row[0] for row in results]

        return jsonify({'users_ids': users_ids})
    except Exception as e:
        print('Error fetching user friends:', e)
        return jsonify({'error': 'Internal Server Error'}), 500
    finally:
        if cursor:
            cursor.close()
        if db:
            db.close()

@app.route('/api/create_friendships/<int:user1_id>/<int:user2_id>', methods=['POST'])
def create_friendship(user1_id, user2_id):
    db, cursor = None, None
    try:
        db, cursor = get_db_cursor()
        
        # Delete the friendship where either user1_id is user1_id and user2_id is user2_id,
        # or vice versa to handle both directions
        cursor.execute('INSERT INTO friendships (user1_id, user2_id) VALUES (%s, %s)', (user1_id, user2_id))
        cursor.execute('DELETE FROM requests WHERE (user1_id=%s AND user2_id=%s)', (user2_id, user1_id))

        db.commit()

        return '', 204  # No content, indicating success
    except Exception as e:
        print('Error deleting friendship:', e)
        return jsonify({'error': 'Internal Server Error'}), 500
    finally:
        if cursor:
            cursor.close()
        if db:
            db.close()



# @app.route('/api/users/<int:user_id>/learn-about-me', methods=['PUT'])
# def update_learn_about_me(user_id):
#     db, cursor = None, None
#     try:
#         db, cursor = get_db_cursor()

#         # Get the data from the request JSON
#         data = request.get_json()

#         # Extract the fields to be updated
#         image_path = data.get('image_path')
#         description = data.get('description')
#         links = data.get('links')


#         if image_path is not NULL:
#             cursor.execute('UPDATE learn_about_me SET image_path = %s WHERE user_id = %s', (image_path, user_id))

#         if description is not NULL:
#             cursor.execute('UPDATE learn_about_me SET description = %s WHERE user_id = %s', (description, user_id))

#         if links is not NULL:
#             cursor.execute('UPDATE learn_about_me SET links = %s WHERE user_id = %s', (links, user_id))
#         db.commit()

#         return '', 204  # No content, indicating success
#     except Exception as e:
#         print('Error updating learn about me information:', e)
#         return jsonify({'error': 'Internal Server Error'}), 500
#     finally:
#         if cursor:
#             cursor.close()
#         if db:
#             db.close()


from flask import jsonify

@app.route('/api/users/<int:user_id>/get-learn-about-me-info', methods=['GET'])
def get_learn_about_me_info(user_id):
    db, cursor = None, None
    try:
        db, cursor = get_db_cursor()

        # Fetch the current information from the learn_about_me table
        cursor.execute('SELECT image_path, description, links FROM learn_about_me WHERE user_id = %s', (user_id,))
        result = cursor.fetchone()

        if result:
            # Return the information as JSON
            return jsonify({
                'image_path': result[0],
                'description': result[1],
                'links': result[2]
            }), 200
        else:
            return jsonify({'message': 'User not found'}), 404

    except Exception as e:
        # Handle exceptions appropriately (e.g., log the error, return an error response)
        return jsonify({'error': str(e)}), 500

    finally:
        if cursor:
            cursor.close()
        if db:
            db.close()


@app.route('/api/users/<int:user_id>/learn-about-me', methods=['PUT'])
def update_learn_about_me(user_id):
    db, cursor = None, None
    try:
        db, cursor = get_db_cursor()

        # Get the data from the request JSON
        data = request.get_json()

        # Extract the fields to be updated
        image_path = data.get('image_path')
        description = data.get('description')
        links = data.get('links')

        print(image_path);

        # Build the SQL update statement based on the provided fields
        update_query = "UPDATE learn_about_me SET "
        params = []

        if image_path is not None:
            update_query += "image_path = %s, "
            params.append(image_path)

        if description is not None:
            update_query += "description = %s, "
            params.append(description)

        if links is not None:
            update_query += "links = %s, "
            params.append(links)

        # Remove the trailing comma and add the WHERE clause
        update_query = update_query.rstrip(', ') + " WHERE user_id = %s"
        params.append(user_id)

        print(update_query)
        print(tuple(params))
        # Execute the update statement if at least one field is provided
        if params:
            cursor.execute(update_query, tuple(params))
            db.commit()

        return jsonify({'message': 'Update successful'}), 204

    except Exception as e:
        # Handle exceptions appropriately (e.g., log the error, return an error response)
        return jsonify({'error': str(e)}), 500

    finally:
        if cursor:
            cursor.close()
        if db:
            db.close()


@app.route('/api/events', methods=['GET'])
def get_events():
    db, cursor = None, None
    try:
        db, cursor = get_db_cursor()

        # Fetch all events from the database
        cursor.execute('SELECT * FROM event')
        events = cursor.fetchall()

        # Convert the result to a list of dictionaries
        event_list = []
        for event in events:
            event_dict = {
                'id': event[0],
                'user_id': event[1],
                'user_name': event[2],
                'description': event[3],
                'time': event[4].strftime('%Y-%m-%d %H:%M:%S') if event[4] else None,
                'location': event[5]

            }
            event_list.append(event_dict)

        return jsonify(event_list), 200

    except Exception as e:
        # Handle exceptions appropriately (e.g., log the error, return an error response)
        return jsonify({'error': str(e)}), 500

    finally:
        if cursor:
            cursor.close()
        if db:
            db.close()


@app.route('/api/events', methods=['POST'])
def create_event():
    data = request.get_json()
    location = data.get('location')
    description = data.get('description')
    user_id = data.get('user_id')
    time = data.get('time')

    try:
        # Establish a connection to the MySQL database
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor()

        cursor.execute('SELECT * FROM users WHERE id=%s', (user_id, ))
        result = cursor.fetchone()
        username = result[2]


        # Insert data into the 'event' table using raw SQL query
        insert_query = "INSERT INTO event (user_id, user_name, description, location, time) VALUES (%s, %s, %s, %s, %s)"
        cursor.execute(insert_query, (user_id, username, description, location, time))

        # Commit the changes to the database
        connection.commit()

        return jsonify({'message': 'Event created successfully'}), 201
    except Exception as e:
        return jsonify({'message': f'Error creating event: {str(e)}'}), 500
    finally:
        # Close the database connection and cursor
        cursor.close()
        connection.close()


@app.route('/api/change-password', methods=['POST'])
def change_password():
    data = request.get_json()

    email = data.get('email')
    new_password = data.get('new_password')
    confirm_password = data.get('confirm_password')


    if new_password != confirm_password:
        return jsonify(error='New password and confirm password do not match'), 400


    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor()

    cursor.execute('UPDATE users SET password = %s WHERE email = %s', (new_password, email))
    connection.commit()

    # Return a success response
    return jsonify(message='Password changed successfully'), 200


# Fetch user info
@app.route('/api/users/<int:user_id>/info', methods=['GET'])
def get_user_info(user_id):
    try:
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor()
        cursor.execute("SELECT * FROM users WHERE id = %s", (user_id,))

        user_info = cursor.fetchone()
        connection.close()

        if user_info:
            return jsonify({
                'nickname': user_info[2],
                'password': user_info[3],
                'account_type': user_info[7],
                'business_name': user_info[4],
                'address': user_info[6],
                'phone': user_info[5]
            })

        return jsonify({'error': 'User not found'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Update user info
@app.route('/api/users/<int:user_id>/info', methods=['PUT'])
def update_user_info(user_id):
    db, cursor = None, None

    try:
        db, cursor = get_db_cursor()
        data = request.get_json()

        nickname = data.get('nickname')
        password = data.get('password')
        account_type = data.get('account_type')
        business_name = data.get('business_name')
        address = data.get('address')
        phone = data.get('phone')

        update_query = "UPDATE users SET "
        params = []

        if nickname is not None:
            update_query += "nickname = %s, "
            params.append(nickname)

        if password is not None:
            update_query += "password = %s, "
            params.append(password)

        if business_name is not None:
            update_query += "business_name = %s, "
            params.append(business_name)

        if phone is not None:
            update_query += "phone = %s, "
            params.append(phone)

        if address is not None:
            update_query += "address = %s, "
            params.append(address)

        if account_type is not None:
            update_query += "account_type = %s, "
            params.append(account_type)

        update_query = update_query.rstrip(', ') + " WHERE id = %s"
        params.append(user_id)
        
        if params:
            cursor.execute(update_query, tuple(params))
            db.commit()

        return jsonify({'message': 'Update successful'}), 200

    except Exception as e:
        # Handle exceptions appropriately (e.g., log the error, return an error response)
        return jsonify({'error': str(e)}), 500

    finally:
        if cursor:
            cursor.close()
        if db:
            db.close()


@app.route('/api/posts/<int:post_id>/<int:user_id>/like', methods=['POST'])
def like_post(post_id, user_id):
    try:
        # Connect to the database
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor()

        # Check if the user has already liked the post
        cursor.execute("SELECT * FROM user_likes WHERE user_id = %s AND post_id = %s", (user_id, post_id))
        user_like = cursor.fetchone()

        if user_like:
            # User has already liked the post, unlike it
            cursor.execute("DELETE FROM user_likes WHERE user_id = %s AND post_id = %s", (user_id, post_id))
            cursor.execute("UPDATE posts SET likes = likes - 1 WHERE id = %s", (post_id,))
            cursor.execute("SELECT * FROM posts WHERE id=%s", (post_id,))
            result = cursor.fetchone()[5];
            connection.commit()
            return jsonify({"liked": False, "likes": result}), 200
        else:
            # User hasn't liked the post yet, like it
            cursor.execute("INSERT INTO user_likes (user_id, post_id) VALUES (%s, %s)", (user_id, post_id))
            cursor.execute("UPDATE posts SET likes = likes + 1 WHERE id = %s", (post_id,))
            cursor.execute("SELECT * FROM posts WHERE id=%s", (post_id,))
            result = cursor.fetchone()[5];
            connection.commit()
            return jsonify({"liked": True, "likes": result}), 200

    except Exception as e:
        print(e)
        connection.rollback()
        return jsonify({"error": "Failed to toggle like"}), 500

    finally:
        cursor.close()
        connection.close()



@app.route('/api/posts/<int:post_id>/like-status/<int:user_id>', methods=['GET'])
def is_liked(post_id, user_id):
    try:
        # Connect to the database
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor()

        # Check if the user has already liked the post
        cursor.execute("SELECT * FROM user_likes WHERE user_id = %s AND post_id = %s", (user_id, post_id))
        user_like = cursor.fetchone()

        if user_like:
            connection.commit()
            return jsonify({"liked": True}), 200
        else:
            connection.commit()
            return jsonify({"liked": False}), 200

    except Exception as e:
        print(e)
        connection.rollback()
        return jsonify({"error": "Failed to toggle like"}), 500

    finally:
        cursor.close()
        connection.close()


@app.route('/api/update_user_event', methods=['POST'])
def update_user_event():

    data = request.get_json()

    user_id = data.get('user_id')
    event_id = data.get('event_id')
    add_relation = data.get('add_relation', False)

    try:
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor()
        
        if add_relation:
            query = "INSERT INTO user_event (user_id, event_id) VALUES (%s, %s)"
            cursor.execute(query, (user_id, event_id))
            connection.commit()
            return jsonify({'message': 'User event added successfully'}), 200

        # If add_relation is False, delete the user-event relationship
        query = "DELETE FROM user_event WHERE user_id = %s AND event_id = %s"
        cursor.execute(query, (user_id, event_id))
        cursor.close()
        connection.commit()
        return jsonify({'message': 'User event deleted successfully'}), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500


# @app.route('/api/user_events/<int:user_id>', methods=['GET'])
# def fetch_user_events(user_id):
#     try:
#         connection = mysql.connector.connect(**db_config)
#         cursor = connection.cursor()
#         # Fetch the event_ids for the given user_id
#         query = "SELECT event_id FROM user_event WHERE user_id = %s"
#         cursor.execute(query, (user_id,))
#         event_ids = cursor.fetchall()
#         # Convert the list of dictionaries to a list of integers
#         print(event_ids);
#         event_ids = [event['event_id'] for event in event_ids]
#         print(event_ids)
#         event_ids = tuple(event_ids);
#         print(event_ids);
#         # Fetch user-specific events
#         query = "SELECT * FROM event WHERE id IN %s"
#         cursor.execute(query, (tuple(event_ids),))
#         user_events = cursor.fetchall()
#         print(user_events)
#         event_list = []
        
#         for event in user_events:
#             event_dict = {
#                 'id': event['id'],
#                 'user_id': event['user_id'],
#                 'user_name': event['user_name'],
#                 'description': event['description'],
#                 'time': event['time'].strftime('%Y-%m-%d %H:%M:%S') if event['time'] else None,
#                 'location': event['location']
#             }
#             event_list.append(event_dict)
        
#         print(event_list)
#         return event_list

#     except Exception as e:
#         print(f'Error fetching user events: {e}')
#         return jsonify({'error': str(e)}), 500


@app.route('/api/user_events/<int:user_id>', methods=['GET'])
def get_user_events(user_id):
    try:
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor()

        # Fetch event_ids from user_event table
        query = "SELECT event_id FROM user_event WHERE user_id = %s"
        cursor.execute(query, (user_id,))
        user_event_ids = [event[0] for event in cursor.fetchall()]
        
        user_event_ids_tuple = tuple(user_event_ids);            
        #cursor.execute('SELECT * FROM event WHERE id IN %s', user_event_ids_tuple)
        #cursor.execute('SELECT * FROM event WHERE id IN (2,3,4)')
        cursor.execute('SELECT * FROM event WHERE id IN (%s)' % ', '.join(['%s'] * len(user_event_ids)), user_event_ids)


        user_events = cursor.fetchall()
        connection.commit()
        return jsonify(user_events), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        if cursor:
            cursor.close()
        if connection:
            connection.close()



@app.route('/create_post', methods=['POST'])
def create_post():
    try:
            connection = mysql.connector.connect(**db_config)
            cursor = connection.cursor()
            image_path = request.form.get('image_path')
            location = request.form.get('location')
            user_id = int(request.form.get('user_id'))
            likes = int(request.form.get('likes'))

            cursor.execute('SELECT nickname FROM users WHERE id = %s', (user_id, ))

            data = cursor.fetchone()
            print(data)
            username = data[0]
            
            print(username)
            cursor.execute("INSERT INTO posts (username, image_path, location, user_id, likes) VALUES (%s, %s, %s, %s, %s)", (username, image_path, location, user_id, likes))
            connection.commit()

            return jsonify({'message': 'Post created successfully'}), 200


    except Exception as e:
        return jsonify({'error': str(e)}), 500



if __name__ == '__main__':
    app.run(debug=True)
