<%@ page import="com.shrineoflostsecrets.util.*"%>
<%@ page import="com.shrineoflostsecrets.constants.*"%>

<%
String inputName = "";
if (null != request.getParameter(JspConstants.DATEPICKER) && request.getParameter(JspConstants.DATEPICKER).length() > 0) {
	inputName = request.getParameter(JspConstants.DATEPICKER);
}
%>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<table>
	<tr>
		<td><a onClick="forward(90, '<%=inputName %>')"><i class="fa-solid fa-arrow-up"></i></a></td>
		<td><a onClick="forward(30, '<%=inputName %>')"><i class="fa-solid fa-arrow-up"></i></a></td>
		<td><a onClick="forward(1, '<%=inputName %>')"><i class="fa-solid fa-arrow-up"></i></a></td>
		<td><a onClick="forward(36000, '<%=inputName %>')"><i class="fa-solid fa-up-long"></i></a><a onClick="forward(360, '<%=inputName %>')"><i
			class="fa-solid fa-arrow-up"></i></a></td>
	</tr>
	<tr>
		<td><span id="season"></span></td>
		<td><span id="month"></span></td>
		<td><span id="day"></span></td>
		<td><span id="year"></span></td>
		
	</tr>
	<tr>
		<td><a onClick="forward(-90, '<%=inputName %>')"><i class="fa-solid fa-arrow-down"></i></a></td>
		<td><a onClick="forward(-30, '<%=inputName %>')"><i class="fa-solid fa-arrow-down"></i></a></td>
		<td><a onClick="forward(-1, '<%=inputName %>')"><i class="fa-solid fa-arrow-down"></i></a></td>
		<td><a onClick="forward(-36000, '<%=inputName %>')"><i class="fa-solid fa-down-long"></i></a><a onClick="forward(-360, '<%=inputName %>')"><i
			class="fa-solid fa-arrow-down"></i></a></td>
	</tr>
</table>
<script>
var now = 0;
var months = [
	  "JAN",
	  "FEB",
	  "MAR",
	  "APR",
	  "MAY",
	  "JUN",
	  "JUL",
	  "AUG",
	  "SEP",
	  "OCT",
	  "NOV",
	  "DEC"
	];
	
var season = [
	  "WINTER",
	  "SPRING",
	  "SUMMER",
	  "FALL"
	];
	
function getYear(time) {
	return floorDiv(time, 360);

}
function getSeasonName(time){
	return season[getSeason(time)];
}
function getSeason(time) {
		return  floorMod(floorDiv(time, 90), 4);	
}
function getMonthName(time){
	return months[getMonth(time)];
}
function getMonth(time) {
	return  floorMod(floorDiv(time, 30), 12);	
}

function getDayOfMonth(time) {
	var dayOfMonth;
	    if (time < 0) {
	      dayOfMonth = floorMod(time + 30, 30);
	    } else {
	      dayOfMonth = floorMod(time, 30);
	    }
	  return dayOfMonth + 1;
	}
	

function floorDiv(a, b) {
	  return Math.floor(a/b);
	}
	
function floorMod(a, b) {
	  return ((a % b) + b) % b;
	}
function setTime(input){
	var month = document.getElementById('month');
	var day = document.getElementById('day');
	var year = document.getElementById('year');
	var season = document.getElementById('season');
	var time = document.getElementById('time');

	month.innerHTML = getMonthName(now);
	year.innerHTML = getYear(now);
	season.innerHTML = getSeasonName(now);
	day.innerHTML = getDayOfMonth(now);
	if(null != input){
		input.value= now

	}
	return false;
	
}
 function forward(amount, inputString){
	 input = document.getElementById(inputString);
	 now = now + amount;
	 setTime(input)
	 if(updateLoc !== null){
		 updateLoc();
	 }
 }

 function setNow(inputString){
	 input = document.getElementById(inputString);
	 if(null != input){
		 now =  parseInt(input.value, 0);
		 setTime(input)
	 }
	 else{
		 alert("input is null");

	 }
 }
 setNow("<%=inputName %>");
</script>