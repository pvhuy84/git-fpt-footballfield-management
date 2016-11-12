package model.dao;

import java.sql.ResultSet;
import java.sql.SQLException;

import model.bean.User;

public class UserDAO extends connectDB {

	// Check exist user in database
	public User checkUser(String phonenumber, String password) {
		User user = null;
		ResultSet rs = null;
		try {
			statement = connection.createStatement();
			System.out.println("input: " + phonenumber + ", " + password);
			String sql = "select * from user where phonenumber = '" + phonenumber + "' and password = '" + password
					+ "'";
			rs = statement.executeQuery(sql);
			if (rs.next()) {
				user = new User(rs.getString(1), rs.getString(2), rs.getString(3), rs.getInt(4));
			}
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return user;
	}

	// Add user
	public String addUser(User user) {
		String status = "";
		String sql = "";
		try {
			// Check phone number exist or not
			sql = "select * from user where phonenumber=? and password=?";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, user.getPhonenumber());
			preparedStatement.setString(2, user.getPassword());
			ResultSet rs = preparedStatement.executeQuery();
			if (rs.next()) {
				status = "Phone number was existed!";
			}

			// Add user to database
			sql = "insert into user values(?, ?, ?, ?)";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, user.getPhonenumber());
			preparedStatement.setString(2, user.getPassword());
			preparedStatement.setString(3, user.getName());
			preparedStatement.setInt(4, user.getRole());
			if (!preparedStatement.execute()) {
				status = "success";
			} else {
				status = "Database error";
			}
			
			preparedStatement.close();
		} catch (Exception e) {
			e.printStackTrace();
			status = "Database error";
		}
		return status;
	}
}