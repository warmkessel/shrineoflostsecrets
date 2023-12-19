<%@ page import="com.shrineoflostsecrets.util.*"%>
<%@ page import="com.shrineoflostsecrets.constants.*"%>

<%
String inputName = "";
if (null != request.getParameter(JspConstants.DATEPICKER)
		&& request.getParameter(JspConstants.DATEPICKER).length() > 0) {
	inputName = request.getParameter(JspConstants.DATEPICKER);
}
%>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<table>
	<tr>
		<td style="text-align: center;"><a
			onClick="forward<%=inputName%>(90, '<%=inputName%>')"><i
				class="fa-solid fa-arrow-up"></i></a></td>
		<td style="text-align: center;"><a
			onClick="forward<%=inputName%>(1, '<%=inputName%>')"><i
				class="fa-solid fa-arrow-up"></i></a></td>
		<td style="text-align: center;"><a
			onClick="forward<%=inputName%>(30, '<%=inputName%>')"><i
				class="fa-solid fa-arrow-up"></i></a></td>
		<td style="text-align: center;"><a
			onClick="forward<%=inputName%>(36000, '<%=inputName%>')"><i
				class="fa-solid fa-up-long"></i></a><a
			onClick="forward<%=inputName%>(360, '<%=inputName%>')"><i
				class="fa-solid fa-arrow-up"></i></a></td>
	</tr>
	<tr>
		<td style="text-align: center;"><span id="<%=inputName%>season"></span></td>
		<td style="text-align: center;"><span id="<%=inputName%>day"></span></td>
		<td style="text-align: center;"><span id="<%=inputName%>month"></span></td>
		<td style="text-align: center;"><span id="<%=inputName%>year"></span></td>

	</tr>
	<tr>
		<td style="text-align: center;"><a
			onClick="forward<%=inputName%>(-90, '<%=inputName%>')"><i
				class="fa-solid fa-arrow-down"></i></a></td>
		<td style="text-align: center;"><a
			onClick="forward<%=inputName%>(-1, '<%=inputName%>')"><i
				class="fa-solid fa-arrow-down"></i></a></td>
		<td style="text-align: center;"><a
			onClick="forward<%=inputName%>(-30, '<%=inputName%>')"><i
				class="fa-solid fa-arrow-down"></i></a></td>
		<td style="text-align: center;"><a
			onClick="forward<%=inputName%>(-36000, '<%=inputName%>')"><i
				class="fa-solid fa-down-long"></i></a><a
			onClick="forward<%=inputName%>(-360, '<%=inputName%>')"><i
				class="fa-solid fa-arrow-down"></i></a></td>
	</tr>
</table>
<script>
	
function forward<%=inputName%>(amount, inputString) {
	  const months = [
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

	  const seasons = ["WINTER", "SPRING", "SUMMER", "FALL"];

	  const input = document.getElementById(inputString);
	  if (input !== null) {
	    let now = parseInt(input.value, 0);
	    now += amount;

	    const monthIndex = Math.floor(now / 30) % 12;
	    document.getElementById('<%=inputName%>month').innerHTML = months[monthIndex];

	    document.getElementById('<%=inputName%>year').innerHTML = Math.floor(now / 360);

	    const seasonIndex = Math.floor(now / 90) % 4;
	    document.getElementById('<%=inputName%>season').innerHTML = seasons[seasonIndex];

	    let dayOfMonth;
	    if (now < 0) {
	      dayOfMonth = ((now % 30) + 30) % 30;
	    } else {
	      dayOfMonth = now % 30;
	    }
	    dayOfMonth += 1;
	    document.getElementById('<%=inputName%>day').innerHTML = dayOfMonth;

	    input.value = now;
	    if (typeof updateTime === 'function') {
	    	updateTime();
	    }
	    return false;
	  }
	}
 forward<%=inputName%>(0, "<%=inputName%>");
</script>