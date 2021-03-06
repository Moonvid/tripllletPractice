<!DOCTYPE HTML>

<html>
<head>
    <title>스프링부트 게시판 서비스</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!-- 부트스트랩 js, jquery 추가-->
    <link rel="stylesheet" href="//unpkg.com/bootstrap@4/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="/css/lib/common.css">

    <style>
        .left{
            text-align: center;
            font-weight: bold;
            background-color: lightgrey;
            width: 150px;
        }

        .button-align{
            text-align: center;
        }
        
        .button{
            display: inline-block;
        }

        .content-title{
            vertical-align: middle;
        }


    </style>

</head>

<body>

    <hr/>
    <div>
        <ul class="navi">
            <li>
                <a href="/">Home</a>
            </li>
            <li>
                <a href="/post/list">Board</a>
            </li>
        </ul>
    </div>
    <hr/>

    <br/><br/>

    <div class="container">
        <!-- 게시물 확인 -->
        <div align="center"><h1>게시물 수정</h1></div>
        <br/>

        <div class="insert-align">
            <div class="container" id="main">
                <div>
                    <div class="panel panel-default content-main">
                        <form name="update" id="update" method="post" action="/post/update/${posts.id}">
                            <input type="hidden" id="id" name="id" value="${posts.id}">
                            <div class="form-group">
                                <label for="writer" class="i-menu">작성자</label>
                                <input type="text" class="form-control" id="writer" name="writer" value="${posts.writer}"/>
                            </div>
                            <div class="form-group">
                                <label for="title" class="i-menu">제목</label>
                                <input type="text" class="form-control" id="title" name="title" value="${posts.title}"/>
                            </div>
                            <div class="form-group">
                                <label for="content" class="i-menu">내용</label>
                                <textarea name="content" id="content" row="5" class="form-control">${posts.content}</textarea>
                            </div>
                            <button type="button" class="btn btn-success btn-sm clearfix pull-right" onclick="ajaxUpdate(${posts.id})">수정완료</button>
                            <button type="button" class="btn btn-success btn-sm clearfix pull-right" onclick="location.href='/post/view/${posts.id}'">수정취소</button>
                            <div class="clearfix"/>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!--
        <div class="row">
            <div class="row">
                <form method="post" action="/post/update/">
                <table class="table table-horizontal table-bordered">
                    <tbody id="tbody">
                        <tr>
                            <td class="left">게시글번호</td><td><input type="hidden" id="id" name="id" value="${posts.id}"/>${posts.id}</td>
                            <td class="left">작성자</td><td><input type="hidden" id="writer" name="writer" value="${posts.writer}"/>${posts.writer}</td>
                        </tr>
                        <tr>
                            <td class="left">제목</td><td colspan="3"><input type="text" id="title" name="title" value="${posts.title}" width="500px"/></td>
                        </tr>
                        <tr>
                            <td class="left" class="content-title">글내용</td><td colspan="3"><textarea id="content" name="content" rows="4" cols="80">${posts.content}</textarea></td>
                        </tr>
                    </tbody>
                </table>
                    <div class="row">
                        <div class="button-align">
                            <div class="button">
                                <button type="submit" class="btn btn-primary">수정완료</button>
                            </div>&nbsp;
                            <div class="button">
                                <button type="button" class="btn btn-primary" onclick="location.href='/post/view/${posts.id}'">수정취소</button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <br/>
        </div>
        -->
    </div>


    <script type="text/javascript">
        function ajaxUpdate(id){

            var idValue = id;

            $.ajax({
                type: 'POST',
                async: false,
                url: '/post/ajaxUpdate/'+idValue,
                data: $("#update").serialize(),
                dataType: 'json',
                success: function(data){
                    if(data.check !== "false"){
                        alert("수정되었습니다.");
                        location.replace("/post/view/"+idValue);
                    }else{
                        alert("수정에 실패하였습니다. 입력 값을 확인하세요.")
                    }
                },
                error:function (request, status, error) {
                    console.log('code : ' + request.status + "\n" + 'message : ' + request.responseText + "\n" + "error : " + error);
                }
            });


        }

    </script>




<!-- 부트스트랩 js, jquery, popper 추가-->
<script src='//unpkg.com/jquery@3/dist/jquery.min.js'></script>
<script src='//unpkg.com/popper.js@1/dist/umd/popper.min.js'></script>
<script src='//unpkg.com/bootstrap@4/dist/js/bootstrap.min.js'></script>

<!--custom js 추가-->
<!--custom js 추가-->
<script src="/js/app/update.js"></script>


</body>


</html>