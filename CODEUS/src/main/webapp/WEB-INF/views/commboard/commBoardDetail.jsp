<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판</title>
<style type="text/css">
	#boardDetailTable{width: 800px; margin: auto; border-collapse: collapse; border-left: hidden; border-right: hidden;}
	#boardDetailTable tr td{padding: 5px;}
	
	.replyTable{margin:auto; width: 500px;}
	
            #my_modal {
                display: none;
                width: 300px;
                padding: 20px 60px;
                background-color: #fefefe;
                border: 1px solid #888;
                border-radius: 3px;
            }

            #my_modal .modal_close_btn {
                position: absolute;
                top: 10px;
                right: 10px;
            }
    
</style>
</head>
<body>
	<c:import url="../member/menubar.jsp"/>
	
	
	
	 <!--**********************************
            Content body start
        ***********************************-->
       <c:if test="${b.bStatus eq '0'}">    
        
         <div class="content-body">
            <div class="container-fluid">
                <div class="row page-titles mx-0">
                    <div class="col-sm-6 p-md-0">
                        <div class="welcome-text">
                            <h4>Hi, welcome back!</h4>
                            <span class="ml-1">Datatable</span>
                        </div>
                    </div>
                    <div class="col-sm-6 p-md-0 justify-content-sm-end mt-2 mt-sm-0 d-flex">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="javascript:void(0)">Table</a></li>
                            <li class="breadcrumb-item active"><a href="javascript:void(0)">Datatable</a></li>
                        </ol>
                    </div>
                </div>
               <div class="row">
                   <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h4 class="card-title">게시판</h4>
                           </div>
                            <div class="card-body">
	 							<button  type="button" 
                                    id="bookmark" class="btn btn-primary">BOOKMARK</button>	
                                
                                    
                                 <c:if test="${ loginUser.mId ne b.bWriter || loginUser.mId eq 'admin' }">   
								  <button  type="button"  id="popup_open_btn"
					                                   class="btn btn-primary" id="report">REPORT</button>	
					                                   
					              </c:if>                     
					                                   
						 <!-- 본문 시작 -->
					<div class="col-lg-12">
                        <div class="card">
                            <div class="card-header">
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover table-responsive-sm" style="color:black">
                                        <thead>
                                            <tr>
								<tr>
									<th>번호</th>
									<td>${ b.bId }</td>
								</tr>
								<tr>
									<th>제목</th>
									<td>${ b.bTitle }</td>
								</tr>
								<tr>
									<th>작성자</th>
									<td>${ b.bWriter }</td>
								</tr>
								<tr>
									<th>작성날짜</th>
									<td>${ b.bCreateDate }</td>
								</tr>
								<tr>
									<th>내용</th>
									<%-- <td>${ board.bContent }</td> --%>
									<!-- 
										이렇게만 두면 엔터가 먹지 않음. 
										DB에는 엔터가 \r\n으로 들어가서 이를 치환해주는 작업 필요
									-->
									
								<% pageContext.setAttribute("newLineChar", "\r\n"); %> <!-- \r\n 말고 그냥 \n도, \r도 가능하다 -->
								<td>${ fn:replace(b.bContent, newLineChar, "<br>") }</td>
								
								</tr>
								<c:url var="bupView" value="bupView.bo">
									<c:param name="bId" value="${ b.bId }"/>
									<c:param name="page" value="${ page }"/>
								</c:url>
								<c:url var="bDelete" value="commbDelete.bo">
										<c:param name="bId" value="${b.bId}"></c:param>
										<c:param name="fileName" value="${b.renameFileName }"></c:param>
								</c:url>
								
								
								<tr>
										<p align="right">
										 <c:if test="${ loginUser.mId eq b.bWriter }">
													<button type="button" class="btn btn-primary" onclick="location.href='${ bupView }'">수정</button>
													<button type="button" class="btn btn-primary" onclick="location.href='${ bDelete }'">삭제</button>
										</c:if>	
										</p>
								</tr>
								
								
								  <script>
										$(function(){
											$('#delete').click(function(){
													var con = confirm("정말 삭제하시겠습니까?");
													if(con){
													var bId = ${b.bId}
													
													location.href='commbDelete.bo?bId=' + bId;
													}else{
														return false;
													}
											});
										});
										</script>
								
								
							</table>
	
							<br><br>
							
							<!-- 본문 끝-->
							
							<!-- 댓글 영역 -->
							
							<jsp:include page="Reply.jsp"></jsp:include>
							
							<!--댓글영역 끝 -->
						
							<br><br>
	
							<p align="center">
								<button  type="button" 
						            onclick="location.href='home.do'" class="btn btn-primary">홈으로</button>	
								<button  type="button" 
						            onclick="location.href='Commblist.bo'" class="btn btn-primary">목록</button>
							</p>
	
	
							<!--신고 모달 창 -->
							
					        <div id="my_modal">
							<form id="postReportForm">
							<br><br><br>
								<h3 align="center" style="color: black">게시글 신고</h3>
							<hr>
								<div class="row">
								<!-- 신고한 회원번호  -->
								<input type="hidden" class="form-control" id="mId" name="mId" value="${sessionScope.loginUser.mId}"> 
								<!-- 신고된 게시글 번호 -->
								<input type="hidden" class="form-control" id="bId" name="bId" value="${b.bId}">
								<!-- 신고된 회원번호   -->
								<input type="hidden" class="form-control" id="reportmId" name="reportmId" value="${b.bWriter}">
								</div> 
							
								<div class="modal_report_div">
								 <input type="radio" name="userReportType" id="radio-1"
									 value="A">&nbsp; <label for="radio-1" style="color: black" 
									class="modal_choise_label">부적절한 내용을 포함</label> <br> 
								 <input type="radio" name="userReportType" id="radio-2"
									value="B">&nbsp; <label for="radio-2" style="color: black" align="center"
									class="modal_choise_label">광고성 내용을 포함</label>
							</div>
							<A id="btncancel" class="modal_close_btn">닫기</A>
						
							<div>
								<hr>
								<p  style="font-size: 12px; color: black">* 신고 내용은 관리자 검토 후 내부정책에 삭제 처리가 진행됩니다. </p>
								<p align="center">
								<button type="button" id="btnreport" class="btn btn-primary" >신 &nbsp; 고</button>
								</p>
							</div>
						</form>
						<br><br>
						
					</div>
					        
				
					        <script>
					        
					            function modal(id) {
					                var zIndex = 9999;
					                var modal = document.getElementById(id);
					
					                // 모달 div 뒤에 희끄무레한 레이어
					                var bg = document.createElement('div');
					                bg.setStyle({
					                    position: 'fixed',
					                    zIndex: zIndex,
					                    left: '0px',
					                    top: '0px',
					                    width: '100%',
					                    height: '100%',
					                    overflow: 'auto',
					                    // 레이어 색갈은 여기서 바꾸면 됨
					                    backgroundColor: 'rgba(0,0,0,0.8)'
					                });
					                document.body.append(bg);
					
					                // 닫기 버튼 처리, 시꺼먼 레이어와 모달 div 지우기
					                modal.querySelector('.modal_close_btn').addEventListener('click', function() {
					                    bg.remove();
					                    modal.style.display = 'none';
					                });
					
					                modal.setStyle({
					                    position: 'fixed',
					                    display: 'block',
					                    boxShadow: '0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19)',
					
					                    // 레이어 보다 한칸 위에 보이기
					                    zIndex: zIndex + 1,
					
					                    // div center 정렬
					                    top: '50%',
					                    left: '50%',
					                    transform: 'translate(-50%, -50%)',
					                    msTransform: 'translate(-50%, -50%)',
					                    webkitTransform: 'translate(-50%, -50%)'
					                });
					            }
					
					            // Element 에 style 한번에 오브젝트로 설정하는 함수 추가
					            Element.prototype.setStyle = function(styles) {
					                for (var k in styles) this.style[k] = styles[k];
					                return this;
					            };
					
					            document.getElementById('popup_open_btn').addEventListener('click', function() {
					                // 모달창 띄우기
					                modal('my_modal');
					            });
					        </script>
					        
					        <script>
					        
					        $("#btnreport").on("click", function() {
					
					     	 if(!confirm('정말로 신고하시겠습니까?')) return;
					     
					         $.ajax({
					            url : "reportCommPost.bo",
					            type : "post",
					            data : $("#postReportForm").serialize(),
					         	dataType : "json",
					            success : function(data) {
					               if(data > 0) {
					                  alert("신고 접수 되었습니다!");
					               } else {
					                  alert("신고 접수 실패! 관리자에게 문의하세요!");                  
					               }
					               bg.remove();
					               modal.style.display = 'none';
					               
					            }
					         });
					      });
					        </script>
					        
							<!-- 모달 창 -->
								</div>
							</div>
						</div>
					</div>
				</div>
		</c:if>
		
		<c:if test="${ loginUser.mId eq 'admin' && b.bStatus eq '1'  }">
     		 
     		 <script language=javascript> 
     		 console.log('123');
     		 alert("이 게시물은 작성자 및 관리자에 의해 삭제된 게시물 입니다."); 
     		 history.go(-1); 
     		 </script>
     		 
      	</c:if>
      	
      	
	
	     <!--**********************************
            Footer start
        ***********************************-->
        <div class="footer">
            <div class="copyright">
                <p>Copyright © Designed &amp; Developed by <a href="#" target="_blank">Quixkit</a> 2019</p>
            </div>
        </div>
        <!--**********************************
            Footer end
        ***********************************-->

        <!--**********************************
           Support ticket button start
        ***********************************-->

        <!--**********************************
           Support ticket button end
        ***********************************-->
  
    <!--**********************************
        Main wrapper end
    ***********************************-->

   
<!--**********************************
        Scripts
    ***********************************-->
    <!-- Required vendors -->
    <script src="${contextPath}/resources/assets/vendor/global/global.min.js"></script>
    <script src="${contextPath}/resources/assets/js/quixnav-init.js"></script>
    <script src="${contextPath}/resources/assets/js/custom.min.js"></script>
    


    <!-- Datatable -->
    <script src="${contextPath}/resources/assets/vendor/datatables/js/jquery.dataTables.min.js"></script>
    <script src="${contextPath}/resources/assets/js/plugins-init/datatables.init.js"></script>

</body>

</html>