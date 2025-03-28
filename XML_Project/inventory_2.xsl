<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" encoding="UTF-8"/>

  <xsl:template match="/">

    <html>
      <head>
        <title>편의점 재고관리</title>
        <style>
          table { 
            width: 100%;
            border-collapse: collapse;
          }
          th, td { 
            padding: 8px 12px; 
            text-align: center; 
            border: 1px solid #ddd; 
          }
          th { background-color: #f2f2f2; }
          .discount { color: blue; font-weight: bold; }
          .expiring { color: orange; font-weight: bold; }
          .normal { color: black; }
          .discount-price { color: red; font-weight: bold; }

          .button-link {
            display: inline-block;
            padding: 10px 20px;
            margin: 10px;
            text-decoration: none;
            background-color: blue;
            color: white;
            font-size: 16px;
            border-radius: 5px;
            text-align: center;
            transition: background-color 0.3s;
          }

          .button-link:hover {
            background-color: skyblue;
          }

          .button-group {
            text-align: center;
          }

          .button-group a {
            margin: 0 15px;
          }

          .content {
            display: none;
          }

          .content:target {
            display: block;
          }

          .button {
            padding: 10px 20px;
            background-color: black;
            color: white;
            border: none;
            border-radius: 5px;
            margin: 5px;
            text-decoration: none;
          }

          .button:hover {
            background-color: gray;
          }

          .fixed-button {
            position: fixed;
            bottom: 20px;
            right: 20px;
            padding: 10px 15px;
            background-color: white;
            border: 1px solid black;
            border-radius: 5px;
            text-decoration: none;
            box-shadow: 2px 2px 5px grey;
          }
          .fixed-button:hover {
            background-color: #f2f2f2;
          }
          
          .container {
            display: flex;
            justify-content: center;
          }

          .rounded-box {
            width: 1500px; 
            height: 150px; 
            background-color: skyblue; 
            border-radius: 20px; 
            color: white; 
            padding: 20px; 
            text-align: center; 
          }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="rounded-box">
		      <img align="left" src="images/convenience_store.jpg" width="200" height="150"/>
			    <img align="right" src="images/cart.png" width="200" height="150"/>
          <h1 align="center">편의점 재고관리</h1>
            <!-- 초기 버튼 화면 -->
           <div id="home" class="button-group">
              <a href="#section1" class="button">모든 상품</a>
              <a href="#section2" class="button">카테고리별 상품</a>
              <a href="#section3" class="button">행사 상품</a>
              <a href="#section4" class="button">유통기한 임박</a>
            </div>
           </div>
          </div>

        <!-- 각 템플릿 영역 -->
        <div id="section1" class="content">
          <h1 align="center">모든 상품</h1>
          <xsl:call-template name="allItemsTemplate"/>
        </div>

        <div id="section2" class="content">
          <h1 align="center">카테고리별 상품</h1>
          <p align="center">카테고리를 선택하시오.</p>
          <!-- 카테고리 목록 -->
          <div class="button-group">
            <xsl:for-each select="inventory/category">
              <xsl:sort select="name" order="ascending"/>
              <xsl:variable name="categoryId" select="@id" />
              
              <!-- 카테고리 링크 생성 -->
              <a href="#{@id}" class="button">
                <xsl:value-of select="@name"/>
              </a>
            </xsl:for-each>
          </div>
        </div>

        <div id="1" class="content">
          <xsl:call-template name="coffeeTemplate"/>
        </div>

        <div id="2" class="content">
          <xsl:call-template name="milkTemplate"/>
        </div>

        <div id="3" class="content">
          <xsl:call-template name="quickfoodTemplate"/>
        </div>

        <div id="4" class="content">
          <xsl:call-template name="ramenTemplate"/>
        </div>

        <div id="5" class="content">
          <xsl:call-template name="snackTemplate"/>
        </div>

        <div id="6" class="content">
          <xsl:call-template name="drinkTemplate"/>
        </div>

        <div id="7" class="content">
          <xsl:call-template name="icecreamTemplate"/>
        </div>

        <div id="8" class="content">
          <xsl:call-template name="disposableProductsTemplate"/>
        </div>

        
        <div id="section3" class="content">
          <h1 align="center">행사 상품</h1>
          <div id="category_button" class="button-group">
            <a href="#dis" class="button">할인중 상품</a>
            <a href="#1plus1" class="button">1+1 상품</a>
            <a href="#2plus1" class="button">2+1 상품</a>
          </div>
        </div>
        
        <div id="dis" class="content">
          <h2 align="center">할인중 상품</h2>
          <xsl:call-template name="discountTemplate"/>
        </div>

        <div id="1plus1" class="content">
          <h2 align="center">1+1 상품</h2>
          <xsl:call-template name="onePlusOneTemplate"/>
        </div>

        <div id="2plus1" class="content">
          <h2 align="center">2+1상품</h2>
          <xsl:call-template name="twoPlusOneTemplate"/>
        </div>

        <div id="section4" class="content">
          <h1 align="center">유통기한 임박 상품</h1>
          <xsl:call-template name="expiringTemplate"/>
        </div>

        <!-- 항상 고정된 "목록 닫기" 버튼 -->
        <a href="#home" class="fixed-button">목록 닫기</a>
      </body>
    </html>
  </xsl:template>

  <!-- 1번 템플릿: 모든 상품 -->
  <xsl:template name="allItemsTemplate">
        <h2>상품 ID 내림차순 정렬</h2>
        <table>
          <thead>
            <tr>
              <th>상품 ID</th>
              <th>상품명</th>
              <th>제조사</th>
              <th>유통기한</th>
              <th>카테고리</th>
              <th>가격</th>
              <th>수량</th>
              <th>비고</th>
              <th>이미지</th>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each select="inventory/category/item">
              <xsl:sort select="id" data-type="number" order="ascending"/>
              <tr>
                <td>
                  <xsl:value-of select="id"/>
                </td>
                <td>
                  <xsl:value-of select="name"/>
                </td>
                <td>
                  <xsl:value-of select="manufacturer"/>
                </td>
                <td>
                  <xsl:value-of select="expiryDate"/>
                </td>
                <td>
                  <xsl:value-of select="../@name"/>
                </td>
                <td>
                  <!-- 할인중인 상품인지 확인하여 가격을 변경 -->
                  <xsl:choose>
                    <xsl:when test="remarks = '할인중'">
                      <xsl:value-of select="price * 0.8"/>￦
                      <span class="discount-price">(할인 20%)</span></xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="price"/>￦
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:value-of select="quantity"/>
                </td>
                <td>
                  <xsl:attribute name="class">
                    <xsl:choose>
                      <xsl:when test="remarks = '할인중'">discount</xsl:when>
                      <xsl:when test="remarks = '유통기한 임박'">expiring</xsl:when>
                      <xsl:otherwise>normal</xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>
                  <xsl:value-of select="remarks"/>
                </td>
                <td>
                  <img src="{image/@src}" width="{image/@width}" height="{image/@height}" alt="상품 이미지"/>
                </td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
  </xsl:template>

  <!-- 2번 템플릿: 카테코리 별 상품정렬 -->
  <!-- 특정 카테고리(커피)만 선택 -->
  <xsl:template name="coffeeTemplate">
    <xsl:for-each select="inventory/category[@id='1']">
      <xsl:variable name="categoryId" select="@id" />

      <!-- 카테고리 이름 출력 -->
      <h2> ● <xsl:value-of select="@name"/></h2>

      <!-- 해당 카테고리의 상품 리스트 출력 -->
      <table>
        <thead>
          <tr>
            <th>상품 ID</th>
            <th>상품명</th>
            <th>제조사</th>
            <th>유통기한</th>
            <th>카테고리</th>
            <th>가격</th>
            <th>수량</th>
            <th>비고</th>
            <th>이미지</th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="item">
            <xsl:sort select="id" data-type="number" order="ascending"/>
            <tr>
              <td><xsl:value-of select="id"/></td>
              <td><xsl:value-of select="name"/></td>
              <td><xsl:value-of select="manufacturer"/></td>
              <td><xsl:value-of select="expiryDate"/></td>
              <td><xsl:value-of select="../@name"/></td>
              <td>
                <xsl:choose>
                  <xsl:when test="remarks = '할인중'">
                    <xsl:value-of select="price * 0.8"/>￦
                    <span class="discount-price">(할인 20%)</span>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="price"/>￦
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <td><xsl:value-of select="quantity"/></td>
              <td>
                <xsl:attribute name="class">
                  <xsl:choose>
                    <xsl:when test="remarks = '할인중'">discount</xsl:when>
                    <xsl:when test="remarks = '유통기한 임박'">expiring</xsl:when>
                    <xsl:otherwise>normal</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:value-of select="remarks"/>
              </td>
              <td>
                <img src="{image/@src}" width="{image/@width}" height="{image/@height}" alt="상품 이미지"/>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </xsl:for-each>
  </xsl:template>

  <!-- 특정 카테고리(유재품)만 선택 -->
  <xsl:template name="milkTemplate">
    <xsl:for-each select="inventory/category[@id='2']">
      <xsl:variable name="categoryId" select="@id" />

      <!-- 카테고리 이름 출력 -->
      <h2> ● <xsl:value-of select="@name"/></h2>

      <!-- 해당 카테고리의 상품 리스트 출력 -->
      <table>
        <thead>
          <tr>
            <th>상품 ID</th>
            <th>상품명</th>
            <th>제조사</th>
            <th>유통기한</th>
            <th>카테고리</th>
            <th>가격</th>
            <th>수량</th>
            <th>비고</th>
            <th>이미지</th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="item">
            <xsl:sort select="id" data-type="number" order="ascending"/>
            <tr>
              <td><xsl:value-of select="id"/></td>
              <td><xsl:value-of select="name"/></td>
              <td><xsl:value-of select="manufacturer"/></td>
              <td><xsl:value-of select="expiryDate"/></td>
              <td><xsl:value-of select="../@name"/></td>
              <td>
                <xsl:choose>
                  <xsl:when test="remarks = '할인중'">
                    <xsl:value-of select="price * 0.8"/>￦
                    <span class="discount-price">(할인 20%)</span>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="price"/>￦
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <td><xsl:value-of select="quantity"/></td>
              <td>
                <xsl:attribute name="class">
                  <xsl:choose>
                    <xsl:when test="remarks = '할인중'">discount</xsl:when>
                    <xsl:when test="remarks = '유통기한 임박'">expiring</xsl:when>
                    <xsl:otherwise>normal</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:value-of select="remarks"/>
              </td>
              <td>
                <img src="{image/@src}" width="{image/@width}" height="{image/@height}" alt="상품 이미지"/>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </xsl:for-each>
  </xsl:template>

  <!-- 특정 카테고리(즉석식품)만 선택 -->
  <xsl:template name="quickfoodTemplate">
    <xsl:for-each select="inventory/category[@id='3']">
      <xsl:variable name="categoryId" select="@id" />

      <!-- 카테고리 이름 출력 -->
      <h2> ● <xsl:value-of select="@name"/></h2>

      <!-- 해당 카테고리의 상품 리스트 출력 -->
      <table>
        <thead>
          <tr>
            <th>상품 ID</th>
            <th>상품명</th>
            <th>제조사</th>
            <th>유통기한</th>
            <th>카테고리</th>
            <th>가격</th>
            <th>수량</th>
            <th>비고</th>
            <th>이미지</th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="item">
            <xsl:sort select="id" data-type="number" order="ascending"/>
            <tr>
              <td><xsl:value-of select="id"/></td>
              <td><xsl:value-of select="name"/></td>
              <td><xsl:value-of select="manufacturer"/></td>
              <td><xsl:value-of select="expiryDate"/></td>
              <td><xsl:value-of select="../@name"/></td>
              <td>
                <xsl:choose>
                  <xsl:when test="remarks = '할인중'">
                    <xsl:value-of select="price * 0.8"/>￦
                    <span class="discount-price">(할인 20%)</span>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="price"/>￦
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <td><xsl:value-of select="quantity"/></td>
              <td>
                <xsl:attribute name="class">
                  <xsl:choose>
                    <xsl:when test="remarks = '할인중'">discount</xsl:when>
                    <xsl:when test="remarks = '유통기한 임박'">expiring</xsl:when>
                    <xsl:otherwise>normal</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:value-of select="remarks"/>
              </td>
              <td>
                <img src="{image/@src}" width="{image/@width}" height="{image/@height}" alt="상품 이미지"/>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </xsl:for-each>
  </xsl:template>

  <!-- 특정 카테고리(라면))만 선택 -->
  <xsl:template name="ramenTemplate">
    <xsl:for-each select="inventory/category[@id='4']">
      <xsl:variable name="categoryId" select="@id" />

      <!-- 카테고리 이름 출력 -->
      <h2> ● <xsl:value-of select="@name"/></h2>

      <!-- 해당 카테고리의 상품 리스트 출력 -->
      <table>
        <thead>
          <tr>
            <th>상품 ID</th>
            <th>상품명</th>
            <th>제조사</th>
            <th>유통기한</th>
            <th>카테고리</th>
            <th>가격</th>
            <th>수량</th>
            <th>비고</th>
            <th>이미지</th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="item">
            <xsl:sort select="id" data-type="number" order="ascending"/>
            <tr>
              <td><xsl:value-of select="id"/></td>
              <td><xsl:value-of select="name"/></td>
              <td><xsl:value-of select="manufacturer"/></td>
              <td><xsl:value-of select="expiryDate"/></td>
              <td><xsl:value-of select="../@name"/></td>
              <td>
                <xsl:choose>
                  <xsl:when test="remarks = '할인중'">
                    <xsl:value-of select="price * 0.8"/>￦
                    <span class="discount-price">(할인 20%)</span>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="price"/>￦
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <td><xsl:value-of select="quantity"/></td>
              <td>
                <xsl:attribute name="class">
                  <xsl:choose>
                    <xsl:when test="remarks = '할인중'">discount</xsl:when>
                    <xsl:when test="remarks = '유통기한 임박'">expiring</xsl:when>
                    <xsl:otherwise>normal</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:value-of select="remarks"/>
              </td>
              <td>
                <img src="{image/@src}" width="{image/@width}" height="{image/@height}" alt="상품 이미지"/>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </xsl:for-each>
  </xsl:template>

  <!-- 특정 카테고리(스낵))만 선택 -->
  <xsl:template name="snackTemplate">
    <xsl:for-each select="inventory/category[@id='5']">
      <xsl:variable name="categoryId" select="@id" />

      <!-- 카테고리 이름 출력 -->
      <h2> ● <xsl:value-of select="@name"/></h2>

      <!-- 해당 카테고리의 상품 리스트 출력 -->
      <table>
        <thead>
          <tr>
            <th>상품 ID</th>
            <th>상품명</th>
            <th>제조사</th>
            <th>유통기한</th>
            <th>카테고리</th>
            <th>가격</th>
            <th>수량</th>
            <th>비고</th>
            <th>이미지</th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="item">
            <xsl:sort select="id" data-type="number" order="ascending"/>
            <tr>
              <td><xsl:value-of select="id"/></td>
              <td><xsl:value-of select="name"/></td>
              <td><xsl:value-of select="manufacturer"/></td>
              <td><xsl:value-of select="expiryDate"/></td>
              <td><xsl:value-of select="../@name"/></td>
              <td>
                <xsl:choose>
                  <xsl:when test="remarks = '할인중'">
                    <xsl:value-of select="price * 0.8"/>￦
                    <span class="discount-price">(할인 20%)</span>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="price"/>￦
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <td><xsl:value-of select="quantity"/></td>
              <td>
                <xsl:attribute name="class">
                  <xsl:choose>
                    <xsl:when test="remarks = '할인중'">discount</xsl:when>
                    <xsl:when test="remarks = '유통기한 임박'">expiring</xsl:when>
                    <xsl:otherwise>normal</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:value-of select="remarks"/>
              </td>
              <td>
                <img src="{image/@src}" width="{image/@width}" height="{image/@height}" alt="상품 이미지"/>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </xsl:for-each>
  </xsl:template>

  <!-- 특정 카테고리(음료수)만 선택 -->
  <xsl:template name="drinkTemplate">
    <xsl:for-each select="inventory/category[@id='6']">
      <xsl:variable name="categoryId" select="@id" />

      <!-- 카테고리 이름 출력 -->
      <h4> ● <xsl:value-of select="@name"/></h4>

      <!-- 해당 카테고리의 상품 리스트 출력 -->
      <table>
        <thead>
          <tr>
            <th>상품 ID</th>
            <th>상품명</th>
            <th>제조사</th>
            <th>유통기한</th>
            <th>카테고리</th>
            <th>가격</th>
            <th>수량</th>
            <th>비고</th>
            <th>이미지</th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="item">
            <xsl:sort select="id" data-type="number" order="ascending"/>
            <tr>
              <td><xsl:value-of select="id"/></td>
              <td><xsl:value-of select="name"/></td>
              <td><xsl:value-of select="manufacturer"/></td>
              <td><xsl:value-of select="expiryDate"/></td>
              <td><xsl:value-of select="../@name"/></td>
              <td>
                <xsl:choose>
                  <xsl:when test="remarks = '할인중'">
                    <xsl:value-of select="price * 0.8"/>￦
                    <span class="discount-price">(할인 20%)</span>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="price"/>￦
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <td><xsl:value-of select="quantity"/></td>
              <td>
                <xsl:attribute name="class">
                  <xsl:choose>
                    <xsl:when test="remarks = '할인중'">discount</xsl:when>
                    <xsl:when test="remarks = '유통기한 임박'">expiring</xsl:when>
                    <xsl:otherwise>normal</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:value-of select="remarks"/>
              </td>
              <td>
                <img src="{image/@src}" width="{image/@width}" height="{image/@height}" alt="상품 이미지"/>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </xsl:for-each>
  </xsl:template>

  <!-- 특정 카테고리(아이스크림)만 선택 -->
  <xsl:template name="icecreamTemplate">
    <xsl:for-each select="inventory/category[@id='7']">
      <xsl:variable name="categoryId" select="@id" />

      <!-- 카테고리 이름 출력 -->
      <h2> ● <xsl:value-of select="@name"/></h2>

      <!-- 해당 카테고리의 상품 리스트 출력 -->
      <table>
        <thead>
          <tr>
            <th>상품 ID</th>
            <th>상품명</th>
            <th>제조사</th>
            <th>유통기한</th>
            <th>카테고리</th>
            <th>가격</th>
            <th>수량</th>
            <th>비고</th>
            <th>이미지</th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="item">
            <xsl:sort select="id" data-type="number" order="ascending"/>
            <tr>
              <td><xsl:value-of select="id"/></td>
              <td><xsl:value-of select="name"/></td>
              <td><xsl:value-of select="manufacturer"/></td>
              <td><xsl:value-of select="expiryDate"/></td>
              <td><xsl:value-of select="../@name"/></td>
              <td>
                <xsl:choose>
                  <xsl:when test="remarks = '할인중'">
                    <xsl:value-of select="price * 0.8"/>￦
                    <span class="discount-price">(할인 20%)</span>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="price"/>￦
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <td><xsl:value-of select="quantity"/></td>
              <td>
                <xsl:attribute name="class">
                  <xsl:choose>
                    <xsl:when test="remarks = '할인중'">discount</xsl:when>
                    <xsl:when test="remarks = '유통기한 임박'">expiring</xsl:when>
                    <xsl:otherwise>normal</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:value-of select="remarks"/>
              </td>
              <td>
                <img src="{image/@src}" width="{image/@width}" height="{image/@height}" alt="상품 이미지"/>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </xsl:for-each>
  </xsl:template>

  <!-- 특정 카테고리(일회용품)만 선택 -->
  <xsl:template name="disposableProductsTemplate">
    <xsl:for-each select="inventory/category[@id='8']">
      <xsl:variable name="categoryId" select="@id" />

      <!-- 카테고리 이름 출력 -->
      <h2> ● <xsl:value-of select="@name"/></h2>

      <!-- 해당 카테고리의 상품 리스트 출력 -->
      <table>
        <thead>
          <tr>
            <th>상품 ID</th>
            <th>상품명</th>
            <th>제조사</th>
            <th>유통기한</th>
            <th>카테고리</th>
            <th>가격</th>
            <th>수량</th>
            <th>비고</th>
            <th>이미지</th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="item">
            <xsl:sort select="id" data-type="number" order="ascending"/>
            <tr>
              <td><xsl:value-of select="id"/></td>
              <td><xsl:value-of select="name"/></td>
              <td><xsl:value-of select="manufacturer"/></td>
              <td><xsl:value-of select="expiryDate"/></td>
              <td><xsl:value-of select="../@name"/></td>
              <td>
                <xsl:choose>
                  <xsl:when test="remarks = '할인중'">
                    <xsl:value-of select="price * 0.8"/>￦
                    <span class="discount-price">(할인 20%)</span>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="price"/>￦
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <td><xsl:value-of select="quantity"/></td>
              <td>
                <xsl:attribute name="class">
                  <xsl:choose>
                    <xsl:when test="remarks = '할인중'">discount</xsl:when>
                    <xsl:when test="remarks = '유통기한 임박'">expiring</xsl:when>
                    <xsl:otherwise>normal</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:value-of select="remarks"/>
              </td>
              <td>
                <img src="{image/@src}" width="{image/@width}" height="{image/@height}" alt="상품 이미지"/>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </xsl:for-each>
  </xsl:template>


  <!-- 3번 템플릿: 행사 상품 -->
  <xsl:template name="discountTemplate">
          <table>
          <thead>
            <tr>
              <th>상품 ID</th>
              <th>상품명</th>
              <th>제조사</th>
              <th>유통기한</th>
              <th>카테고리</th>
              <th>가격</th>
              <th>수량</th>
              <th>비고</th>
              <th>이미지</th>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each select="inventory/category/item[remarks = '할인중']">
              <xsl:sort select="id" data-type="number" order="ascending"/>
              <tr>
                <td>
                  <xsl:value-of select="id"/>
                </td>
                <td>
                  <xsl:value-of select="name"/>
                </td>
                <td>
                  <xsl:value-of select="manufacturer"/>
                </td>
                <td>
                  <xsl:value-of select="expiryDate"/>
                </td>
                <td>
                  <xsl:value-of select="../@name"/>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="remarks = '할인중'">
                      <xsl:value-of select="price * 0.8"/>￦
                      <span class="discount-price">(할인 20%)</span></xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="price"/>￦
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:value-of select="quantity"/>
                </td>
                <td>
                  <xsl:attribute name="class">
                    <xsl:choose>
                      <xsl:when test="remarks = '할인중'">discount</xsl:when>
                      <xsl:when test="remarks = '유통기한 임박'">expiring</xsl:when>
                      <xsl:otherwise>normal</xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>
                  <xsl:value-of select="remarks"/>
                </td>
                <td>
                  <img src="{image/@src}" width="{image/@width}" height="{image/@height}" alt="상품 이미지"/>
                </td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
        <p align="center"><a href="#section3">이전으로</a></p>
  </xsl:template>

  <!-- 3번 템플릿 중 1+1 상품 -->
  <xsl:template name="onePlusOneTemplate">
    <table>
          <thead>
            <tr>
              <th>상품 ID</th>
              <th>상품명</th>
              <th>제조사</th>
              <th>유통기한</th>
              <th>카테고리</th>
              <th>가격</th>
              <th>수량</th>
              <th>비고</th>
              <th>이미지</th>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each select="inventory/category/item[remarks = '1+1']">
              <xsl:sort select="id" data-type="number" order="ascending"/>
              <tr>
                <td>
                  <xsl:value-of select="id"/>
                </td>
                <td>
                  <xsl:value-of select="name"/>
                </td>
                <td>
                  <xsl:value-of select="manufacturer"/>
                </td>
                <td>
                  <xsl:value-of select="expiryDate"/>
                </td>
                <td>
                  <xsl:value-of select="../@name"/>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="remarks = '할인중'">
                      <xsl:value-of select="price * 0.8"/>￦
                      <span class="discount-price">(할인 20%)</span></xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="price"/>￦
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:value-of select="quantity"/>
                </td>
                <td>
                  <xsl:attribute name="class">
                    <xsl:choose>
                      <xsl:when test="remarks = '할인중'">discount</xsl:when>
                      <xsl:when test="remarks = '유통기한 임박'">expiring</xsl:when>
                      <xsl:otherwise>normal</xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>
                  <xsl:value-of select="remarks"/>
                </td>
                <td>
                  <img src="{image/@src}" width="{image/@width}" height="{image/@height}" alt="상품 이미지"/>
                </td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
        <p align="center"><a href="#section3">이전으로</a></p>
  </xsl:template>

  <!-- 3번 템플릿 중 2+1 상품 -->
  <xsl:template name="twoPlusOneTemplate">
    <table>
            <thead>
              <tr>
                <th>상품 ID</th>
                <th>상품명</th>
                <th>제조사</th>
                <th>유통기한</th>
                <th>카테고리</th>
                <th>가격</th>
                <th>수량</th>
                <th>비고</th>
                <th>이미지</th>
              </tr>
            </thead>
            <tbody>
              <xsl:for-each select="inventory/category/item[remarks = '2+1']">
                <tr>
                  <td>
                    <xsl:value-of select="id"/>
                  </td>
                  <td>
                    <xsl:value-of select="name"/>
                  </td>
                  <td>
                    <xsl:value-of select="manufacturer"/>
                  </td>
                  <td>
                    <xsl:value-of select="expiryDate"/>
                  </td>
                  <td>
                    <xsl:value-of select="../@name"/>
                  </td>
                  <td>
                    <xsl:value-of select="price"/>￦</td>
                  <td>
                    <xsl:value-of select="quantity"/>
                  </td>
                  <td>
                    <xsl:value-of select="remarks"/>
                  </td>
                  <td>
                    <img src="{image/@src}" width="{image/@width}" height="{image/@height}" alt="상품 이미지"/>
                  </td>
                </tr>
              </xsl:for-each>
            </tbody>
          </table>
          <p align="center"><a href="#section3">이전으로</a></p>
  </xsl:template>

  <!-- 4번 템플릿: 유통기한 임박 상품 -->
  <xsl:template name="expiringTemplate">
    <p>
          <table>
            <thead>
              <tr>
                <th>상품 ID</th>
                <th>상품명</th>
                <th>제조사</th>
                <th>유통기한</th>
                <th>카테고리</th>
                <th>가격</th>
                <th>수량</th>
                <th>비고</th>
                <th>이미지</th>
              </tr>
            </thead>
			  <tbody>
				  <xsl:for-each select="inventory/category/item[remarks = '유통기한 임박']">
					  <!-- 유통기한 남은 일수 계산 -->
					  <xsl:variable name="currentDate" select="/inventory/currentDate" />
					  <xsl:variable name="expiryDate" select="expiryDate" />

					  <!-- 날짜 차이 계산 (yyyyMMdd 형식으로 계산) -->
					  <xsl:variable name="daysLeft" select="number(concat(substring($expiryDate, 1, 4), substring($expiryDate, 5, 2), substring($expiryDate, 7, 2))) - number(concat(substring($currentDate, 1, 4), substring($currentDate, 5, 2), substring($currentDate, 7, 2)))" />

					  <!-- 유통기한 임박 메시지 -->
					  <xsl:variable name="remarksUpdated" select="concat('유통기한 임박 (', $daysLeft, '일 남음)')" />

					  <tr>
						  <td>
							  <xsl:value-of select="id" />
						  </td>
						  <td>
							  <xsl:value-of select="name" />
						  </td>
						  <td>
							  <xsl:value-of select="manufacturer" />
						  </td>
						  <td>
							  <xsl:value-of select="expiryDate" />
						  </td>
						  <td>
							  <xsl:value-of select="../@name" />
						  </td>
						  <td>
							  <xsl:value-of select="price" />￦
						  </td>
						  <td>
							  <xsl:value-of select="quantity" />
						  </td>
						  <td>
							  <xsl:attribute name="class">
								  <xsl:value-of select="'expiring'" />
							  </xsl:attribute>
							  <xsl:value-of select="$remarksUpdated" />
						  </td>
						  <td>
							  <img src="{image/@src}" width="{image/@width}" height="{image/@height}" alt="상품 이미지" />
						  </td>
					  </tr>
				  </xsl:for-each>
			  </tbody>

		  </table>
		  <a href="#section4">처음으로</a>
    </p>
  </xsl:template>

</xsl:stylesheet>
