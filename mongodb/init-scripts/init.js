// MongoDB initialization script
// This script will run when MongoDB starts for the first time

// Create application database and user
db = db.getSiblingDB('appdb');

// Create a collection with sample data
db.users.insertMany([
  {
    name: "John Doe",
    email: "john.doe@example.com",
    created: new Date()
  },
  {
    name: "Jane Smith",
    email: "jane.smith@example.com", 
    created: new Date()
  }
]);

// Create indexes
db.users.createIndex({ "email": 1 }, { unique: true });
db.users.createIndex({ "created": 1 });

print("MongoDB initialization completed successfully!");
