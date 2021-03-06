package com.example.practice.controller;

import com.example.practice.domain.Posts;
import com.example.practice.domain.PostsRepository;
import com.example.practice.service.PostsService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.time.LocalDate;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@AllArgsConstructor
public class WebRestController{

    @Autowired
    private PostsRepository postsRepository;

    @Autowired
    private PostsService postsService;

    // Pageable을 사용한 list
    /*
    @GetMapping("/post/list")
    public ModelAndView list(ModelAndView mav, @PageableDefault(sort = {"id"}, direction = Sort.Direction.DESC) Pageable pageable){

        Page<Posts> postsPage = postsRepository.findAll(pageable);
        System.out.println(postsPage);
        mav.addObject("postsPage", postsPage);

        mav.setViewName("post/list");
        //mav.addObject("posts", postsRepository.findAll());

        return mav;
    }
    */

//    // 일반 리스트
//    @GetMapping("/post/list")
//    public ModelAndView list(ModelAndView mav){
//
//        List<Posts> postsList = postsRepository.findAll();
//        mav.addObject("postsList", postsList);
//
//        mav.setViewName("post/list");
//        //mav.addObject("posts", postsRepository.findAll());
//
//        return mav;
//    }

    // 검색
    @GetMapping("/post/list")
    public ModelAndView search(@RequestParam(value="keyword", required = false, defaultValue = "") String keyword,
                               @RequestParam(value="page", defaultValue = "0") Integer page,
                               @RequestParam(value="row", defaultValue = "10") Integer row,
                               ModelAndView mav){

        // 페이징에 쓰기위한 Map params 값 생성
        Map<String, Object> params = new HashMap<String, Object>(){{
            put("keyword", keyword);
            put("sort", "created_Date");
            put("order", 1);
            put("offset", page * row);
            put("count", row);
        }};
        System.out.println("params = " + params);


        List<Posts> postsList = postsService.searchPosts(params);  // 검색어 유무에 따른 게시글 리스트를 받아옴



        int totalCount = postsService.count(params);                // keyword로 검색 된 전체 데이터 개수
        System.out.println("totalCount = " + totalCount);

        setPaginationData(mav,totalCount,page, row);

        if(params.get(keyword) != null){
            mav.addObject("searchKeyword",params.get(keyword));
        }

        mav.addObject("postsList", postsList);
        mav.setViewName("/post/list");

        return mav;
    }



    // 글쓰기 폼 이동
    @GetMapping("/post/insertForm")
    public ModelAndView insertForm(ModelAndView mav){
        mav.setViewName("post/insert");

        return mav;
    }

    // form submit을 이용한 글쓰기
    @PostMapping("/post/insert")
    public ModelAndView insert(Posts p, ModelAndView mav){

        System.out.println("p = " + p);
        Posts posts = postsRepository.save(p);

        mav.addObject("posts",postsRepository.findAll());
        mav.setViewName("redirect:/post/list");

        return mav;
    }

    // ajax 통신을 이용한 글쓰기
    @PostMapping("/post/ajaxInsert")
    public Object ajaxInsert(Posts p){

        System.out.println(p);

        Map<String, Object> ajaxResult = new HashMap<String, Object>();

        ajaxResult.put("id", p.getId());
        ajaxResult.put("writer", p.getWriter());
        ajaxResult.put("title", p.getTitle());
        ajaxResult.put("content", p.getContent());
        ajaxResult.put("createdDate", p.getCreatedDate());
        ajaxResult.put("modifiedDate", p.getModifiedDate());
        ajaxResult.put("deletedDate", p.getDeletedDate());
        ajaxResult.put("check", "true");

        try{
            postsRepository.save(p);
        } catch (Exception e){
            ajaxResult.put("check", "false");
            e.printStackTrace();;
            throw e;
        } finally {
        }

        // 입력 성공,실패 관련하여 postsRepository.save(p); 부분을
        // try catch로 확인 후
        // put으로 "check", true 또는 false 값을 넣어준뒤
        // map을 리턴해준뒤 success에서 매개변수.check == true, false로
        // 입력 성공 실패 확인 후 alert 띄어줄 수 도 있음.

//        mav.addObject("posts",ajaxResult);
//        mav.setViewName("redirect:/post/list");

        return ajaxResult;
    }

    // 글 보기
    @GetMapping("/post/view/{id}")
    public ModelAndView view(@PathVariable("id") Long id, ModelAndView mav){

        Posts posts = postsRepository.getOne(id);

        mav.addObject("posts",posts);
        mav.setViewName("post/view");

        return mav;
    }

    // ajax로 글 읽기는.. spinner 효과를 쓸려고 하는게 아닌 이상 큰 메리트가 없음.
    // 우선 보류하고 나중에 댓글 처리 할때 다시 하기
    @GetMapping("/post/ajaxView/{id}")
    public Object ajaxView(@PathVariable("id") Long id, ModelAndView mav){


        Posts p = postsRepository.getOne(id);

        Map<String, Object> ajaxResult = new HashMap<String, Object>();

        ajaxResult.put("id", p.getId());
        ajaxResult.put("writer", p.getWriter());
        ajaxResult.put("title", p.getTitle());
        ajaxResult.put("content", p.getContent());
        ajaxResult.put("createdDate", p.getCreatedDate());
        ajaxResult.put("modifiedDate", p.getModifiedDate());
        ajaxResult.put("deletedDate", p.getDeletedDate());

        return ajaxResult;
    }

    // 삭제
    @GetMapping("/post/delete/{id}")
    public ModelAndView delete(@PathVariable("id") Long id, ModelAndView mav){

        Posts posts = postsRepository.getOne(id);   // id 값으로 해당 row 불러온다.
        posts.setDeletedDate(new Date());                // 불러온 row의 컬럼 중 deletedDate의 값을 현재 시간으로 변경
        postsRepository.save(posts);                // 바뀐 정보를 다시 저장

        mav.setViewName("redirect:/post/list");

        return mav;

    }

    // ajax 삭제
    @GetMapping("/post/ajaxDelete/{id}")
    public Object ajaxDelete(Posts posts){

        Posts p = postsRepository.getOne(posts.getId());
        p.setDeletedDate(new Date());
        postsRepository.save(p);

        HashMap<String, Object> ajaxResult = new HashMap<>();

        ajaxResult.put("id", p.getId());
        ajaxResult.put("writer", p.getWriter());
        ajaxResult.put("title", p.getTitle());
        ajaxResult.put("content", p.getContent());
        ajaxResult.put("createdDate", p.getCreatedDate());
        ajaxResult.put("modifiedDate", p.getModifiedDate());
        ajaxResult.put("deletedDate", p.getDeletedDate());

        return ajaxResult;

    }

    // 수정 폼 이동
    @GetMapping("/post/updateForm/{id}")
    public ModelAndView updateForm(@PathVariable("id") Long id, ModelAndView mav){

        Posts posts = postsRepository.getOne(id);
        mav.addObject("posts", posts);
        mav.setViewName("post/update");

        return mav;

    }

    // 업데이트
    @PostMapping("/post/update/{id}")
    public ModelAndView update(@RequestParam("id") Long id, Posts p, ModelAndView mav){

        Posts posts = postsRepository.getOne(p.getId());

        posts.setTitle(p.getTitle());
        posts.setContent(p.getContent());
        posts.setModifiedDate(new Date());

        postsRepository.save(posts);

        mav.setViewName("redirect:/post/view/{id}");

        return mav;

    }

    // ajax 업데이트
    @PostMapping("/post/ajaxUpdate/{id}")
    public Object ajaxUpdate(Posts posts){

        Posts p = postsRepository.getOne(posts.getId());

        p.setWriter(posts.getWriter());
        p.setTitle(posts.getTitle());
        p.setContent(posts.getContent());

        HashMap<String, Object> ajaxResult = new HashMap<>();
        ajaxResult.put("check", "true");

        try{
            postsRepository.save(p);
        } catch (Exception e){
            ajaxResult.put("check", "false");
            e.printStackTrace();
            throw e;
        } finally {
        }

        ajaxResult.put("id", p.getId());
        ajaxResult.put("writer", p.getWriter());
        ajaxResult.put("title", p.getTitle());
        ajaxResult.put("content", p.getContent());
        ajaxResult.put("createdDate", p.getCreatedDate());
        ajaxResult.put("modifiedDate", p.getModifiedDate());
        ajaxResult.put("deletedDate", p.getDeletedDate());

        return ajaxResult;
    }


    // 페이징 참고
    protected void setPaginationData(ModelAndView mav, long totalCount, int pageNumber, int pageSize) {

        Map<String, Object> paginationData = new HashMap<>();
        paginationData.put("pagesAvailable", (int) Math.ceil((double) totalCount / pageSize)); // 전체 데이터개수를 한 페이지 당 보여줄 데이터 개수로 나누어 사용할 페이지 수를 구한다.
        paginationData.put("pageNumber", pageNumber);                                          // 시작되는 페이지 넘버 값을 설정. default는 0부터
        paginationData.put("pageSize", pageSize);                                              // 한 페이지당 보여줄 데이터 개수, 10개씩 보여주는걸로

        mav.addObject("paginationData", paginationData);
        mav.addObject("totalCount", totalCount);
    }




}
