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



npm install express
Npm install nodemon
Npm install mongoose
Npm init
models->Department.js
const mongoose = require('mongoose');
const departmentSchema = new mongoose.Schema({
_
id: String,
name: { type: String, required: true, unique: true },
location: String
});
module.exports = mongoose.model('departments'
, departmentSchema);
models->Employee.js
const mongoose = require('mongoose');
const employeeSchema = new mongoose.Schema({
_
id: String,
name: { type: String, required: true },
email: { type: String, required: true, unique: true },
position: String,
departmentId: {type: String,ref: 'departments'
, required: true},
projectIds: [{type: String, ref: 'projects'}]
});
module.exports = mongoose.model('employees'
, employeeSchema);
models->Project.js
const mongoose = require('mongoose');
const projectSchema = new mongoose.Schema({
_
id: String,
name: { type: String, required: true },
description: String,
deadline: Date
});
module.exports = mongoose.model('projects'
, projectSchema);
routes->DepartmentRoute.js
const express=require('express')
const router = express.Router()
const Department = require('
../models/Department')
const Employee = require('
../models/Employee')
const { mongoose } = require('mongoose')
router.get('/'
, async (req,res)=>{
try {
const results = await Department.find()
if (results) {
res.status(200).json(results)
} else {
res.status(404).send("Sorry, No Data Found !")
}
} catch (error) {
console.error(error);
res.status(500).send("Server Error !")
}
})
// give a dept id and get the employees who are working there
router.get('/emp/:did'
, async (req,res)=>{
try {
const did = req.params.did
//const results = await
Employee.find({departmentId:did}).populate("departmentId")
//display only emp id, name, department name
const results = await Employee.find(
{departmentId:did},
{name:1,departmentId:1}).populate("departmentId").sort({ name:-1})
//manipulate the results
const filterResult=results.map(emp=>({
employee
id:emp.
id,
_
_
employee
name:emp.name,
_
department
name:emp.departmentId.name
_
}))
if (results) {
} else {
res.status(200).json(filterResult)
res.status(404).send("Sorry, No Data Found !")
}
} catch (error) {
console.error(error);
res.status(500).send("Server Error !")
}
})
//find how many employees are working in a department
//shows the employee count along with each deapartment details
router.get('/empcount/'
, async (req,res)=>{
try {
const results = await Department.aggregate([
{
$lookup:{
from:"employees"
,
localField:"
id"
,
_
foreignField:"departmentId"
as:"emps"
,
}
},
{
$project:{
name:1,
location:1,
number
of
employees:{$size:"$emps"}
_
_
}
}
])
if (results) {
res.status(200).json(results)
} else {
res.status(404).send("Sorry, No Data Found !")
}
} catch (error) {
console.error(error);
res.status(500).send("Server Error !")
}
})
module.exports=router
route->EmployeeRoute.js
const express=require('express')
const router = express.Router()
const Employee = require('
../models/Employee')
const { mongoose } = require('mongoose')
router.get('/'
, async (req,res)=>{
try {
const results = await Employee.find()
if (results) {
res.status(200).json(results)
} else {
res.status(404).send("Sorry, No Data Found !")
}
} catch (error) {
console.error(error);
res.status(500).send("Server Error !")
}
})
router.get('/procount/'
try {
, async (req,res)=>{
const results = await Employee.find()
const newResults = results.map(emp=>({
id:emp.
id,
_
name:emp.name,
number
of
projects:emp.projectIds.length
_
_
}))
if (results) {
res.status(200).json(newResults)
} else {
res.status(404).send("Sorry, No Data Found !")
}
} catch (error) {
console.error(error);
res.status(500).send("Server Error !")
}
})
//get project names along with employee details
router.get('/withprojects/'
, async (req, res) => {
try {
const results = await Employee.find()
.populate('projectIds'
,
'name')
.populate('departmentId'
,
'name');
const formattedResults = results.map(emp => ({
employee
id: emp.
id,
_
_
employee
name: emp.name,
_
department: emp.departmentId.name,
projects: emp.projectIds.map(project => project.name)
}));
if (results) {
} else {
res.status(200).json(formattedResults);
res.status(404).send("Sorry, No Data Found !");
}
} catch (error) {
console.error(error);
res.status(500).send("Server Error !");
}
});
//get the distinct postions of employees
router.get('/positions/'
, async (req, res) => {
try {
const results = await Employee.distinct('position');
if (results) {
res.status(200).json(results);
} else {
res.status(404).send("Sorry, No Data Found !");
}
} catch (error) {
console.error(error);
res.status(500).send("Server Error !");
}
});
//along with distinct postions, show how many employees hold that
postion like Enigeers:2 HR:1
router.get('/positions/count/'
, async (req, res) => {
try {
const results = await Employee.aggregate([
{
$group: {
id: "$position"
,
_
count: { $sum: 1 }
}
},
{
$project: {
position: "$
id"
,
employee
_
count: "$count"
,
_
id: 0
_
}
}
]);
if (results) {
res.status(200).json(results);
} else {
res.status(404).send("Sorry, No Data Found !");
}
} catch (error) {
console.error(error);
res.status(500).send("Server Error !");
}
});
//find employees who are an engineer or support engineer
router.get('/engineers/'
, async (req, res) => {
try {
'engineer'
const results = await Employee.find({
position: { $in: ['Engineer'
,
,
'support engineer'] }
}).populate('departmentId'
,
'name');
if (results) {
'Support Engineer'
res.status(200).json(results);
} else {
res.status(404).send("Sorry, No Data Found !");
}
,
} catch (error) {
console.error(error);
res.status(500).send("Server Error !");
}
});
module.exports=router
route->ProjectRoutes.js
const express=require('express')
const router = express.Router()
const Project = require('
../models/Project')
const { mongoose } = require('mongoose')
router.get('/'
, async (req,res)=>{
try {
const results = await Project.find()
if (results) {
res.status(200).json(results)
} else {
res.status(404).send("Sorry, No Data Found !")
}
} catch (error) {
console.error(error);
res.status(500).send("Server Error !")
}
})
*/
/*show the employee names along with each project
router.get('/withemployees/'
try {
, async (req, res) => {
const results = await Project.aggregate([
{
$lookup: {
from: "employees"
,
localField: "
id"
,
_
foreignField: "projectIds"
as: "employees"
,
}
},
{
$project: {
project
id: "$
id"
,
_
project
_
name: "$name"
_
description: 1,
deadline: 1,
,
employees: {
$map: {
input: "$employees"
as: "emp"
,
,
in: {
employee
id: "$$emp.
id"
,
_
_
employee
name: "$$emp.name"
_
position: "$$emp.position"
,
}
}
}
}
}
]);
if (results) {
} else {
res.status(200).json(results);
res.status(404).send("Sorry, No Data Found !");
}
} catch (error) {
console.error(error);
res.status(500).send("Server Error !");
}
});
module.exports=router
index.js
const express = require('express');
const app =express();
const port=3001;
const mongoose = require('mongoose')
const deptrt= require('
./routes/DepartmentRoute')
const projectrt= require('
./routes/ProjectRoutes')
const emprt= require('
./routes/EmployeeRoute')
app.use(express.json())
app.use('/dept'
,deptrt)
app.use('/project'
,projectrt)
app.use('/emp'
,emprt)
mongoose.connect('mongodb://localhost:27017/employeeDB').then(()=>{
console.log("Database connected")
}).catch((error)=>{
console.error(error); })
app.listen(port,()=>{
console.log(`Server is running on ${port}`);
})
