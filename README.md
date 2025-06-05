# Assignment01

   middlewares->errorHandler.js

const errorHandler=(err,req,res,next)=>{
const statusCode=err.statusCode || 500
res.status(statusCode).json({
success:false,
code:statusCode,
message:err.message || "Internal Server Error"
})
next()
}
module.exports=errorHandler

models->Project.js

const mongoose = require('mongoose');
const { Schema } = mongoose;
const projectSchema = new Schema({
name: { type: String, required: true },
description: { type: String },
manager: { type: Schema.Types.ObjectId, ref: 'User'
true }
});
const Project = mongoose.model('Project'
module.exports = Project;
, projectSchema);
, required:


models->Task.js


const mongoose = require('mongoose');
const { Schema } = mongoose;
const taskSchema = new Schema({
title: { type: String, required: true },
description: { type: String },
project: { type: Schema.Types.ObjectId, ref: 'Project'
required: true },
assignedTo: { type: Schema.Types.ObjectId, ref: 'User'
required: true },
dueDate: { type: Date }
,
,
});
const Task = mongoose.model('Task'
module.exports = Task;
, taskSchema);


models->User.js


const mongoose = require('mongoose');
const { Schema } = mongoose;
// User model
const userSchema = new Schema({
name: { type: String, required: true },
email: { type: String, required: true, unique: true },
password: { type: String, required: true }
});
const User = mongoose.model('User'
module.exports = User
, userSchema);


route->projectRoute.js


const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');
const getAllDocuments = require('
../service/getall');
const Project = require('
../models/Project');
const Task = require('
../models/Task');
// GET all projects - Question 1
router.get('/'
, async (req, res) => {
getAllDocuments(res, Project);
});
//Question 2: GET all tasks for a specific project ID
router.get('/:projectId/tasks'
, async (req, res) => {
const { projectId } = req.params;
// Validation for projectId
if (!mongoose.Types.ObjectId.isValid(projectId)) {
return res.status(400).json({
success: false,
error: 'Invalid project ID format.
'
});
}
try {
// First check if project exists
const project = await Project.findById(projectId);
if (!project) {
return res.status(404).json({
success: false,
message: 'Project not found.
'
});
}
// Get all tasks for this project
const tasks = await Task.find({ project: projectId })
.populate('assignedTo'
,
'name email')
.select('title description dueDate');
if (tasks.length === 0) {
return res.status(404).json({
success: false,
message: 'No tasks found for this project.
'
});
}
const response = tasks.map(task => ({
id: task.
id,
_
title: task.title,
description: task.description,
dueDate: task.dueDate,
assignedTo: {
id: task.assignedTo.
id,
_
name: task.assignedTo.name,
email: task.assignedTo.email
}
}));
res.status(200).json({
success: true,
projectId: projectId,
projectName: project.name,
taskCount: tasks.length,
tasks: response
});
} catch (err) {
console.error('Error fetching project tasks:'
, err);
res.status(500).json({
success: false,
error: 'Server error while retrieving project tasks.
'
,
details: err.message
});
}
});
// Question 3: GET project manager details
router.get('/:projectId/manager'
, async (req, res) => {
const { projectId } = req.params;
// Validation for projectId
if (!mongoose.Types.ObjectId.isValid(projectId)) {
return res.status(400).json({
success: false,
error: 'Invalid project ID format.
'
});
}
try {
const project = await
Project.findById(projectId).populate('manager'
if (!project) {
return res.status(404).json({
success: false,
message: 'Project not found.
'
,
'name email');
project.
});
}
if (!project.manager) {
return res.status(404).json({
success: false,
message: 'Manager details not found for this
'
}
details.
});
res.status(200).json({
success: true,
projectName: project.name,
managerName: project.manager.name,
managerEmail: project.manager.email
});
} catch (err) {
console.error('Error fetching manager details:'
, err);
res.status(500).json({
success: false,
error: 'Server error while retrieving manager
'
,
details: err.message
});
}
});
// Question 4: GET tasks and assigned users for a project
router.get('/:projectId/tasks-users'
, async (req, res) => {
const { projectId } = req.params;
// Validation for projectId
if (!mongoose.Types.ObjectId.isValid(projectId)) {
return res.status(400).json({
success: false,
error: 'Invalid project ID format.
'
});
}
try {
// First check if project exists
const project = await Project.findById(projectId);
if (!project) {
return res.status(404).json({
success: false,
message: 'Project not found.
'
});
}
// Find tasks by project ID, populate assignedTo with user name
only
const tasks = await Task.find({ project: projectId })
.populate('assignedTo'
,
'name')
.select('title assignedTo');
if (tasks.length === 0) {
return res.status(404).json({
success: false,
message: 'No tasks found for this project.
'
});
}
const response = tasks.map(task => ({
taskName: task.title,
userName: task.assignedTo.name
}));
res.status(200).json({
success: true,
projectId: projectId,
projectName: project.name,
taskCount: tasks.length,
tasksUsers: response
});
} catch (err) {
console.error('Error retrieving tasks and users:'
res.status(500).json({
success: false,
error: 'Server error while retrieving tasks and
, err);
'
users.
}
,
details: err.message
});
});
module.exports = router;
route->taskRoute.js
const express = require('express');
const router = express.Router();
const Tasks = require('
../models/Task');
const Projects = require('
../models/Project');
const mongoose = require('mongoose');
const getAllDocuments = require('
../service/getall');
router.get('/'
, async (req, res) => {
getAllDocuments(res,Tasks)
});
// Additional endpoint: GET task by ID with validation
router.get('/:taskId'
, async (req, res) => {
const { taskId } = req.params;
// Validation for taskId
if (!mongoose.Types.ObjectId.isValid(taskId)) {
return res.status(400).json({
success: false,
error: 'Invalid task ID format.
'
});
}
try {
const task = await Task.findById(taskId)
.populate('assignedTo'
,
'name email')
.populate('project'
,
'name description');
if (!task) {
return res.status(404).json({
success: false,
message: 'Task not found.
'
});}
res.status(200).json({
success: true,
data: task
});
} catch (err) {
console.error('Error fetching task:'
res.status(500).json({
success: false,
, err);
error: 'Server error while retrieving task.
details: err.message
'
,
});
}
});
module.exports = router;
route->userRoute.js
const express = require('express');
const router = express.Router();
const Users = require('
../models/User');
const getAllDocuments = require('
// GET all departments
router.get('/'
, async (req, res) => {
getAllDocuments(res,Users)
../service/getall');
});
module.exports = router;
service->getall.js
const getAllDocuments = async (res,Model) => {
try {
const result=await Model.find()
if(result){
res.status(200).json(result)
}
else{
}
} catch (err) {
res.status(404).send("sorry");
throw new Error(`Error fetching documents:
${err.message}`);
}
};
module.exports = getAllDocuments ;
index.js
const express=require('express');
const app=express();
const port=3006;
const mongoose= require('mongoose');
const errorHandleMid=require('
./middlewares/errorHandler')
const projectert=require('
./route/projectRoute')
const taskert=require('
./route/taskRoute')
const userert=require('
./route/userRoute')
app.use(express.json())
app.use(errorHandleMid)
app.use('/project'
,projectert)
app.use('/task'
,taskert)
app.use('/user'
,userert)
app.use(errorHandleMid)
mongoose.connect('mongodb://localhost:27017/taskDB').then(()=>{
console.log("Database connected")
}).catch((error)=>{
console.error(error);
})
app.listen(port,()=>{
console.log(`
server is running on ${port}`);
})
1.Create an endpoint to retrieve all data from the User, Project,
and Task collections. Implement this task with code reusability.
2. Create an endpoint to retrieve all tasks associated with a
specific project ID. Endpoint: GET /project/{projectId}/tasks
3. Create an endpoint to retrieve the manager of a given project
ID. Return only the project name, manager name, and email address.
Endpoint: GET /project/{projectId}/manager
4. Create an endpoint to retrieve the tasks and the users they are
assigned to for a specific project ID. The result should contain
only the task name and user name.
Endpoint: GET /project/{projectId}/tasks-users
5. Ensure your API handles errors gracefully and returns
appropriate HTTP status codes.
6. Include validation for the request parameters where necessary.

