-- 07. 남성보다 여성의 수가 가장 많은 지역 구하기
-- 전국의 각 읍/면/동 기준 남성의 수보다 여성의 수가 가장 많은 지역을 구한다.
USE basic_query;
SELECT C.*
FROM (SELECT A.ADMINIST_ZONE_NO
           , A.ADMINIST_ZONE_NM
           , A.MALE_POPLTN_CNT - A.FEMALE_POPLTN_CNT AS "남성인구수-여성인구수"
      FROM (SELECT A.ADMINIST_ZONE_NO
                 , A.ADMINIST_ZONE_NM
                 , MAX(A.MALE_POPLTN_CNT)   AS MALE_POPLTN_CNT
                 , MAX(A.FEMALE_POPLTN_CNT) AS FEMALE_POPLTN_CNT
            FROM (SELECT A.ADMINIST_ZONE_NO
                       , A.ADMINIST_ZONE_NM
                       , CASE WHEN A.POPLTN_SE_CD = 'M' THEN A.POPLTN_CNT ELSE 0 END AS MALE_POPLTN_CNT
                       , CASE WHEN A.POPLTN_SE_CD = 'F' THEN A.POPLTN_CNT ELSE 0 END AS FEMALE_POPLTN_CNT
                  FROM (SELECT A.ADMINIST_ZONE_NO
                             , A.ADMINIST_ZONE_NM
                             , A.POPLTN_SE_CD
                             , SUM(A.POPLTN_CNT) AS POPLTN_CNT
                        FROM TB_POPLTN A
                        WHERE A.ADMINIST_ZONE_NO NOT LIKE '_____00000'
                          AND A.POPLTN_SE_CD IN ('M', 'F')
                          AND A.STD_MT = '202304'
                        GROUP BY A.ADMINIST_ZONE_NO, A.ADMINIST_ZONE_NM, A.POPLTN_SE_CD
                        ORDER BY A.ADMINIST_ZONE_NO, A.POPLTN_SE_CD) A) A
            GROUP BY A.ADMINIST_ZONE_NO, A.ADMINIST_ZONE_NM) A) C
ORDER BY C.`남성인구수-여성인구수` ASC
LIMIT 1;

-- 08. 남성/여성 비율이 가장 높은 지역과 가장 낮은 지역 구하기
-- 전국의 각 읍/면/동 기준 남성 비율 및 여성 비율이 가장 높은 지역 구하기.
SELECT B.*
   FROM
       (
          SELECT A.ADMINIST_ZONE_NO, A.ADMINIST_ZONE_NM, A.MALE_POPLTN_CNT, A.FEMALE_POPLTN_CNT
               , ROUND((MALE_POPLTN_CNT/TOT_POPLTN_CNT) * 100, 2) AS "남성인구비율"
               , ROUND((FEMALE_POPLTN_CNT/TOT_POPLTN_CNT) * 100, 2) AS "여성인구비율"
               , ROW_NUMBER() OVER(ORDER BY ROUND((MALE_POPLTN_CNT/TOT_POPLTN_CNT) * 100, 2)) AS "남성인구비율순위"
               , ROW_NUMBER() OVER(ORDER BY ROUND((FEMALE_POPLTN_CNT/TOT_POPLTN_CNT) * 100, 2)) AS "여성인구비율순위"
            FROM
               (
                 SELECT A.ADMINIST_ZONE_NO, A.ADMINIST_ZONE_NM
                      , MAX(A.MALE_POPLTN_CNT) AS MALE_POPLTN_CNT
                      , MAX(A.FEMALE_POPLTN_CNT) AS FEMALE_POPLTN_CNT
                      , MAX(A.MALE_POPLTN_CNT) + MAX(A.FEMALE_POPLTN_CNT) AS TOT_POPLTN_CNT
                   FROM
                      (
                        SELECT A.ADMINIST_ZONE_NO, A.ADMINIST_ZONE_NM
                             , CASE WHEN A.POPLTN_SE_CD = 'M' THEN A.POPLTN_CNT ELSE 0 END AS MALE_POPLTN_CNT
                             , CASE WHEN A.POPLTN_SE_CD = 'F' THEN A.POPLTN_CNT ELSE 0 END AS FEMALE_POPLTN_CNT
                          FROM
                             (
                               SELECT
                                      A.ADMINIST_ZONE_NO, A.ADMINIST_ZONE_NM, A.POPLTN_SE_CD
                                    , SUM(A.POPLTN_CNT) AS POPLTN_CNT
                                 FROM TB_POPLTN A
                                WHERE A.ADMINIST_ZONE_NO NOT LIKE '_____00000'
                                  AND A.POPLTN_SE_CD IN ('M', 'F')
                                  AND A.POPLTN_CNT > 0
                                  AND A.STD_MT = '202304'
                                GROUP BY A.ADMINIST_ZONE_NO, A.ADMINIST_ZONE_NM, A.POPLTN_SE_CD
                                ORDER BY A.ADMINIST_ZONE_NO, A.POPLTN_SE_CD
                             ) A
                       ) A
                   GROUP BY A.ADMINIST_ZONE_NO, A.ADMINIST_ZONE_NM
                ) A
        ) B
WHERE B.남성인구비율순위 = 1 OR B.여성인구비율순위 = 1;

