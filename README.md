# Convenience Store Inventory Management Program

This project is a **convenience store inventory management system** developed to efficiently manage and process inventory data. It utilizes **XML, XSD, and XSLT** to store and display product information in XML format.

## Key Features

*   **Comprehensive Product Display:** Lists all products, sorted by ID in descending order.
*   **Category-based Classification:** Organizes and displays products by category.
*   **Discounted Product Filtering:** Filters and shows currently discounted items.
*   **Expiration Date Management:** Manages products nearing their expiration date and displays warnings.

## Technologies Used

*   **XML:** Used for structuring and storing product information.
*   **XSD:** Defines the structure and data types of XML documents for data validation.
*   **XSLT:** Transforms XML data into various display formats (e.g., HTML) for different features.


# Convenience Store Inventory Management Program

This project is a **convenience store inventory management system** developed to efficiently manage and process inventory data. It utilizes **XML, XSD, and XSLT** to store and display product information in XML format.

## Key Features

*   **Comprehensive Product Display:** Lists all products, sorted by ID in descending order.
*   **Category-based Classification:** Organizes and displays products by category.
*   **Discounted Product Filtering:** Filters and shows currently discounted items.
*   **Expiration Date Management:** Manages products nearing their expiration date and displays warnings.

## Technologies Used

*   **XML:** Used for structuring and storing product information.
*   **XSD:** Defines the structure and data types of XML documents for data validation.
*   **XSLT:** Transforms XML data into various display formats (e.g., HTML) for different features.

---

# 편의점 재고관리 프로그램

21113420 박성원 | 21113370 류동영

## 1. 프로젝트 개요

이 프로젝트는 편의점 재고를 관리하기 위한 XML 기반 시스템입니다. XML로 상품 정보를 저장하고, XSD로 데이터 구조를 검증하며, XSLT 템플릿을 통해 다양한 HTML 형태로 재고 목록을 출력합니다.

### 주요 XSLT 템플릿 기능

- 전체 상품 출력
- 카테고리별 상품 분류
- 할인 상품 필터링
- 유통기한 임박 상품 표시

---

## 2. 주제 선정 이유

편의점 재고 관리를 보다 효율적으로 수행할 수 있는 시스템이 필요하다고 판단하여 프로젝트를 기획하게 되었습니다.

### 주요 기능

- 상품 목록을 **ID 기준 내림차순**으로 출력
- 상품을 **카테고리별 분류**하여 그룹화
- **할인중, 행사(1+1, 2+1) 상품**만 따로 추출
- **유통기한 임박(7일 미만)** 상품에 경고 표시

---

## 3. 사용된 기술

- **XML**: 상품 데이터 구조화 및 저장
- **XSD**: 데이터 구조와 타입을 명세하고 유효성 검증
- **XSLT**: XML 데이터를 HTML로 변환하여 출력 형태 구성

---

## 4. 프로젝트 구성 및 주요 작업

### XML 요소 구조

- `inventory`: 최상위 요소, `currentDate` 속성과 여러 `category` 포함
- `category`: 카테고리 이름(`name`), 구분자(`id`) 속성 보유
- `item`: 실제 상품
  - `id`, `name`, `manufacturer`, `expiryDate`, `price`, `quantity`, `remarks`, `image` 요소 포함
- `image`: 필수 `src`, 선택적 `width`, `height` 속성

### XSD 스키마
- 각 XML 요소 구조를 정의하고 필수 속성과 데이터 타입을 명시
  
<img src="/img/1.png" height="500"/>

---

## 5. XSLT 템플릿 설명

<img src="/img/2.png"/>

### 공통 사항

- `remarks='할인중'`: `font=blue`, 가격 할인 표시 → 예: `2800₩(할인20%)`
- `remarks='유통기한 임박'`: `font=orange`, 남은 일자 표시 → 예: `유통기한 임박(4일 남음)`
- 각 테이블 하단에 `닫기 버튼` 존재
- `call-template`으로 템플릿 이름 기준 불러오기

---

### 템플릿 1: 전체 상품 출력

- 상품 ID 기준 **오름차순 정렬**
- 출력 항목: ID, 이름, 카테고리, 가격, 수량, 입고일, 유통기한, 상태, 비고, 이미지

  <img src="/img/3.png"/>

### 템플릿 2: 카테고리별 상품 출력

- 상품을 카테고리별로 그룹화 및 정렬
- 각 버튼 클릭 시 해당 카테고리 템플릿 호출
- 하이퍼링크 사용: `categoryIndex() + position()` → `category-1`, `category-2` 형식

  <img src="/img/4.png"/>

  <img src="/img/5.png"/>

### 템플릿 3: 할인 상품 목록 출력

- `remarks`가 할인중, 1+1, 2+1인 상품 필터링
- 할인 가격 계산 후 표시

<img src="/img/6.png"/>


```xslt
<xsl:for-each select="inventory/item[remarks='할인중']">
```
<img src="/img/7.png"/>

```xslt
<xsl:for-each select="inventory/item[remarks='1+1']">
```
<img src="/img/8.png"/>

```xslt
<xsl:for-each select="inventory/item[remarks='2+1']">
```
<img src="/img/9.png"/>

### 템플릿 4: 유통기한 임박 상품 출력

이 템플릿은 유통기한이 **1주일 미만으로 남은 상품**들을 필터링하여 테이블 형태로 출력합니다.

#### 주요 기능

- `xsl:if` 조건문을 사용하여 유통기한 임박 여부 판단
- `substring()`을 활용해 `expiryDate`에서 연, 월, 일 분리
- `concat()`으로 `YYYYMMDD` 형식의 문자열 조합
- `number()`로 숫자로 변환 후 현재 날짜와 비교하여 남은 일 수 계산
- 남은 일 수가 **7일 미만**인 경우에만 출력하며, 비고란에 `유통기한 임박(남은 X일)`으로 표시

#### 코드 예시

```xslt
<xsl:if test="number(concat(substring(expiryDate,1,4), substring(expiryDate,6,2), substring(expiryDate,9,2))) - 
              number(concat(substring(currentDate,1,4), substring(currentDate,6,2), substring(currentDate,9,2))) &lt; 7">
  <tr>
    <td>
      <xsl:value-of select="name"/>
    </td>
    <td style="color: orange;">
      유통기한 임박(<xsl:value-of select="남은일수"/>일 남음)
    </td>
  </tr>
</xsl:if>
```
#### 출력 형태

<img src="/img/10.png"/>

- 테이블 상단에 **현재 날짜와 템플릿 제목** 출력
- 상품별 항목:
  - 상품명
  - 제조사
  - 유통기한
  - 현재 남은 일수 (예: 유통기한 임박(4일 남음))
  - 이미지 (상품 이미지 표시)
- 비고 칸은 오렌지색으로 표시하며, `"유통기한 임박"` 메시지와 남은 일수를 함께 출력
- 테이블 하단에 **[목록 닫기]** 버튼 포함 (메뉴로 돌아가기)

#### 출력 예시


> 비고 영역은 오렌지색(`style="color:orange;"`)으로 강조되고, 남은 일수가 표시됩니다.

#### XSLT 조건 처리 예시

```xslt
<xsl:if test="number(concat(substring(expiryDate,1,4), substring(expiryDate,6,2), substring(expiryDate,9,2))) - 
              number(concat(substring(currentDate,1,4), substring(currentDate,6,2), substring(currentDate,9,2))) &lt; 7">
  <tr>
    <td><xsl:value-of select="name"/></td>
    <td><xsl:value-of select="manufacturer"/></td>
    <td><xsl:value-of select="expiryDate"/></td>
    <td style="color:orange;">
      유통기한 임박 (<xsl:value-of select="남은일수"/>일 남음)
    </td>
    <td><img src="{image/@src}" width="{image/@width}" height="{image/@height}" /></td>
  </tr>
</xsl:if>
```

## 📅 수정 기록

| 날짜         | 내용 |
|--------------|------|
| 2024-11-19 | XML 데이터를 카테고리별로 분류하고 목록을 구성함 |
| 2024-11-20 | XSL 기능 추가 (1번: 모든 품목 출력, 2번: 카테고리별 출력)  
DTD → XSD 변경 / XML 데이터 추가 / 바로가기 링크 및 하이퍼링크 구현 |
| 2024-11-22 | XML 품목 데이터 추가 |
| 2024-11-27 | 3번 템플릿(할인 상품 목록) 구현  
할인중 품목에 대해 할인된 가격 출력 기능 추가 |
| 2024-11-28 | 4번 템플릿(유통기한 임박 상품) 완성  
substring + concat + number 함수 사용하여 날짜 계산 처리 |
| 2024-12-01 | 전체 XML 데이터 입력 완료 / 에러 점검 완료 |
| 2024-12-02 | XSLT 스타일 수정  
메인 메뉴를 버튼형 테이블로 변경 / 제목 옆에 이미지 추가 |
| 2024-12-07 | 버튼 클릭 시 `call-template`로 템플릿 불러오는 구조로 변경  
둥근 사각형 UI로 스타일 수정 / 카테고리 `id` 속성 처리 및 XSD 반영 |
| 2024-12-08 | 카테고리별 테이블 개별 생성 / `call-template`을 이용해 각각 불러오도록 구현 |
| 2024-12-10 | XSLT, XML, XSD 최종 정리 완료 / 발표용 PPT 제작 |

---

## 🛠 개선사항

* 스타일 디자인 개선 필요
* 코드 구조 및 처리 로직 최적화 필요
* XML 데이터 항목 추가 및 다양성 확보 필요
* XSLT 2.0으로 버전 업 시 날짜·가격 계산 등 처리 간소화 가능
* JavaScript를 활용한 화면 동적 구성 및 시각적 개선

---

## 🔗 참고자료

- [CSS 기능 및 예제](https://www.w3schools.com/css/default.asp)
- [XPath 함수 설명](https://www.tcpschool.com/xml/xml_xpath_filterExpression)
- [HTML 태그 요약](https://miaow-miaow.tistory.com/84)
- 수업 강의자료 및 교재



     
