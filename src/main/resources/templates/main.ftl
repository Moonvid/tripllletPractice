<!DOCTYPE HTML>


<html>
<head>
    <title>스프링부트 게시판 서비스</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!-- 부트스트랩 js, jquery 추가-->
    <link rel="stylesheet" href="//unpkg.com/bootstrap@4/dist/css/bootstrap.min.css">

    <style>
        .t-title{
            text-align: center;
            font-weight: bold;
            background-color: lightgrey;
            width: 150px;
        }

        .t-number{
            width: 200px;
        }
        
        .all{
            text-align: center;
        }


    </style>

</head>

<body>
    <h1 align="center">스프링부트로 만든 웹 게시판</h1>
    <br/><br/>

    <div class="container">
        <div class="col-md-12">
            <button type="button" class="btn btn-primary" data-toggle="modal" onclick="location.href='/insertForm'" >글 등록</button>
        </div>

        <br/>
        <br/>

        <!-- 목록 출력 영역 -->
        <#if posts?has_content>
        <table class="table table-horizontal table-bordered">
            <thead class="thead-strong">
                <tr>
                    <th class="t-title t-number">게시글번호</th>
                    <th class="t-title">제목</th>
                    <th class="t-title">작성자</th>
                    <th class="t-title">최근수정일</th>
                </tr>
            </thead>
            <tbody id="tbody">
                <#list posts as item>
                <tr onclick="location.href='/view/${item.id}'" class="all">
                    <td>${item.id}</td>
                    <td>${item.title}</td>
                    <td>${item.writer}</td>
                    <td>${item.modifiedDate}</td>
                </tr>
                </#list>
            </tbody>
        </table>
            <form action="/search">
                <div class="row">
                    <div class="search-align">
                        <div class="input">
                            <input type="text" name="title" id="title"/>
                        </div>&nbsp;
                        <div class="button">
                            <button type="submit" class="btn btn-primary btn-success">검색</button>
                        </div>
                    </div>
                </div>
            </form>
        <#else>
            <div>
                <h4 class="all"> 등록된 게시글이 없습니다.</h4>
            </div>
        </#if>
    </div>



    <!--
     Modal 영역
    <div class="modal fade" id="savePostsModal" tabindex="-1" role="dialog" aria-labelledby="savePostsLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="savePostsLabel">게시글 등록</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="form-group">
                            <label for="title">제목</label>
                            <input type="text" class="form-control" id="title" placeholder="제목을 입력하세요" required>
                        </div>
                        <div class="form-group">
                            <label for="writer"> 작성자 </label>
                            <input type="text" class="form-control" id="writer" placeholder="작성자를 입력하세요" required>
                        </div>
                        <div class="form-group">
                            <label for="content"> 내용 </label>
                            <textarea class="form-control" id="content" placeholder="내용을 입력하세요"></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-primary" id="btn-save">등록</button>
                </div>
            </div>
        </div>
    </div>
    -->

    <!-- 부트스트랩 js, jquery, popper 추가-->
    <script src='//unpkg.com/jquery@3/dist/jquery.min.js'></script>
    <script src='//unpkg.com/popper.js@1/dist/umd/popper.min.js'></script>
    <script src='//unpkg.com/bootstrap@4/dist/js/bootstrap.min.js'></script>

    <!--custom js 추가-->
    <script src="/js/app/main.js"></script>


</body>




</html>