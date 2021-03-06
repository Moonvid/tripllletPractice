<#--
 * Copyright 2011 Alan Shaw
 *
 * http://www.freestyle-developments.co.uk
 * https://github.com/alanshaw/pagination-freemarker-macros
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and limitations
 * under the License.
-->

<#--
 * Pagination macros.
 *
 * The use of these macros requires either an model attribute called "paginationData" to be set or if you want to call
 * it something else, or have more than one list of items that needs paginating, you can use the "bind" macro to set
 * the current pagination data that subsequent calls to other macros will use.
 *
 * Either way, the pagination data object is expected to contain (at least) the following properties:
 *
 * pageNumber -> The current page number
 * pageSize -> The number of items in each page
 * pagesAvailable -> The total number of pages
 * sortDirection -> The sorting direction (ascending or descending)
 * sortField -> The field currently sorted by
 *
 *
 * Page links consist of the current request url and a query string that looks like:
 *
 * ?field=&page=&size=&direction=
 *
 *
 * Localization messages are looked up using the following keys:
 *
 * pagination.first -> Text for the first page link (default "« First")
 * pagination.last -> Text for the last page link (default "Last »")
 * pagination.next -> Text for the next page link (default "Next »")
 * pagination.previous -> Text for the previous page link (default "« Previous")
 * pagination.counter -> Text for the page counter (default "{0} of {1}")
-->

<#--
 * Assign the current data to the object called "paginationData" if set.
-->
<#if paginationData??>
    <#assign data = paginationData />
</#if>

<#--
 * Bind pagination data to the current data set these macros are using.
-->
<#macro bind paginationData>
    <#assign data = paginationData />
</#macro>

<#--
 * Outputs the first page link
-->
<#macro first>
    <#if (data.pagesAvailable > 0)>
        <#if (data.pageNumber < 1)>
            <#local classAttr = "class=\"disabled\"" />
        <#else>
            <#local classAttr = "" />
        </#if>
        <#local text>
            <<
        </#local>
        <@page 0, text, classAttr/>
    </#if>
</#macro>

<#--
 * Outputs the last page link
-->
<#macro last>
    <#if (data.pagesAvailable > 0)>
        <#if (data.pageNumber >= data.pagesAvailable - 1)>
            <#local classAttr = "class=\"disabled\"" />         <#-- 로컬 변수 선언하는 #local -->
        <#else>
            <#local classAttr = "" />
        </#if>
        <#local text>
            >>
        </#local>
        <@page data.pagesAvailable - 1, text, classAttr/>
    </#if>
</#macro>

<#--
 * Outputs the next page link
-->
<#macro next>
    <#if (data.pageNumber >= data.pagesAvailable - 1)>
        <#local pageNumber = data.pageNumber />
        <#local classAttr = "class=\"disabled\"" />
    <#else>
        <#local pageNumber = data.pageNumber + 1 />
        <#local classAttr = "" />
    </#if>
    <#local text>

    </#local>
    <@nextHtml pageNumber, text, classAttr/>
</#macro>

<#--
 * Outputs the previous page link
-->
<#macro previous>
    <#if (data.pageNumber < 1)>
        <#local pageNumber = data.pageNumber />
        <#local classAttr = "class=\"disabled\"" />
    <#else>
        <#local pageNumber = data.pageNumber - 1 />
        <#local classAttr = "" />
    </#if>
    <#local text>
    </#local>
    <@previousHtml pageNumber, text, classAttr/>
</#macro>

<#--
 * Outputs the page numbers and links
 *
 * @param maxPages (Optional) The maximum number of page links to show
 * @param separator (Optional) The separator between page links
-->
<#macro numbers maxPages = 9 separator = " | ">
    <#if (data.pagesAvailable > 0)>
        <#local pagesBefore = (maxPages / 2)?floor />
        <#local pagesAfter = (maxPages / 2)?floor />
        <#if maxPages % 2 == 0>
            <#local pagesBefore = pagesBefore - 1 />
        </#if>
        <#local pageNumMin = data.pageNumber - pagesBefore />
        <#local pageNumMax = data.pageNumber + pagesBefore />
        <#if (pageNumMin < 0)>
            <#local pageNumMax = pageNumMax + (0 - pageNumMin) />
            <#local pageNumMin = 0 />
        </#if>
        <#if (pageNumMax >= data.pagesAvailable)>
            <#local pageNumMin = pageNumMin - (pageNumMax - data.pagesAvailable) />
            <#local pageNumMax = data.pagesAvailable - 1 />
            <#if (pageNumMin < 0)>
                <#local pageNumMin = 0 />
            </#if>
            <#if (pageNumMax < 0)>
                <#local pageNumMax = 0 />
            </#if>
        </#if>
        <#list pageNumMin..pageNumMax as pageNumber>
            <#if pageNumber == data.pageNumber>
                <#local classAttr = "class=\"active\"" />
            <#else>
                <#local classAttr = "" />
            </#if>
            <@page pageNumber, "", classAttr/><#if pageNumber_has_next></#if>
        </#list>
    </#if>
</#macro>

<#--
 * Outputs a link to a specific page.
 *
 * @param pageNumber To page number ot link to
 * @param text (Optional) The link text (Defaults to page number if not set)
 * @param attributes (Optional) Any HTML attributes to add to the element
-->
<#macro page pageNumber text = "" attributes = "">
    <#if text == "">
        <#local text = (pageNumber + 1)?string />
    </#if>
    <#if (attributes != "" && attributes?starts_with(" ") == false)>
        <#local attributes = " " + attributes />
    </#if>
<#--<li ${attributes}><a href="?page=${pageNumber}<#if RequestParameters.sub?exists>&sub=${RequestParameters.sub}</#if><#if RequestParameters.slug?exists>&slug=${RequestParameters.slug}</#if>">${text?html}</a></li>-->
    <li ${attributes}><a href="javascript:paging(${pageNumber});">${text?html}</a></li>&nbsp;
</#macro>


<#macro nextHtml pageNumber text = "" attributes = "">
    <#if text == "">
        <#local text = (pageNumber + 1)?string />
    </#if>
    <#if (attributes != "" && attributes?starts_with(" ") == false)>
        <#local attributes = " " + attributes />
    </#if>
    <li ${attributes}><a href="javascript:paging(${pageNumber});"><i class="mdi mdi-skip-next"></i></a></li>
</#macro>

<#macro previousHtml pageNumber text = "" attributes = "">
    <#if text == "">
        <#local text = (pageNumber + 1)?string />
    </#if>
    <#if (attributes != "" && attributes?starts_with(" ") == false)>
        <#local attributes = " " + attributes />
    </#if>
    <li ${attributes}><a href="javascript:paging(${pageNumber});"><i class="mdi mdi-skip-previous"></i></a></li>
</#macro>



<#--
 * Outputs the current page number and the total pages
-->
<#macro counter>
    <#if data.pagesAvailable == 0>
        <#local pagesAvailable = 1 />
    <#else>
        <#local pagesAvailable = data.pagesAvailable />
    </#if>
    ${data.pageNumber+1}, ${pagesAvailable}
</#macro>

<#--
 * Outputs a link to sort by a field.

 * @param field The field to sort by. If field is different to the current sort field, the link will change the sort
 * field but not the sort direction. If the field is the same as the current sort field, the link will change the sort
 * direction.
 * @param text (Optional) The link text. If no text is specified the field name is used with a upper case first letter.
 * @param attributes (Optional) Any HTML attributes to add to the element
 * @param directions (Optional) An array of two items. The words being used in data.sortDirection to describe
 * the sorting direction of ascending or descending. Default: ["Asc", "Desc"]. So we can compare the current sorting
 * direction and switch to the converse.
-->
<#macro sort field text = "" attributes = "" directions = ["Asc", "Desc"]>
    <#if field == data.sortField>
    <#-- Change sort direction -->
        <#if data.sortDirection?lower_case == directions[0]?lower_case>
            <#local direction = directions[1] />
        <#else>
            <#local direction = directions[0] />
        </#if>
    <#else>
    <#-- Change sort field (leave sort direction) -->
        <#local direction = data.sortDirection />
    </#if>
    <#if text == "">
        <#local text = field?cap_first />
    </#if>
    <#if (attributes != "" && attributes?starts_with(" ") == false)>
        <#local attributes = " " + attributes />
    </#if>
    <a href="?field=${field?url}&amp;page=${data.pageNumber}&amp;size=${data.pageSize}&amp;direction=${direction?url}"${attributes}>${text?html}</a>
</#macro>