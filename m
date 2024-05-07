Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FFA71B3B;
	Tue,  7 May 2024 22:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715120621; cv=none; b=d4wKQHBV75y1BPoWzxmV8bW0sxmj8uiphpUj0G5ugmJHpaF4cQqo7omhzeVAAFznSWsXoPOwZrQzXu5sJOmwOyIPPafPYTjSe6+ISLI2i6Cew4pYFlKdcm7wzlskINRF7J1LeI02pX0+n0LT/VBcEtfNS/OW3RQtiMeowJWgXls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715120621; c=relaxed/simple;
	bh=P4brHrrgJ2mTiTC1ckZrdUGU9DeItluptwKQtPpGElE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=qWr3cTiC05xtW8ekl+Z8If4CASgTMlCaKIuuxD3S1e4+Rq7zzbllY2gcUn7DoX7ipu9+Q52e5ipO61B+4TAdN4o2oaOuqQMO8aSBBMCAtzOz88cURVS5p12UWlHpL2sJ+3F1h0rIKFvqw3aQ/wEHf3gHibBTN13KjXdI2mBCpyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=T/s6UHog; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="T/s6UHog"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 447KWo8i022725;
	Tue, 7 May 2024 22:23:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	from:date:subject:mime-version:content-type
	:content-transfer-encoding:message-id:to:cc; s=qcppdkim1; bh=XfS
	Hw2hvPwpopsQU0foCtoE5ITn09j8z/DnzkIhGvs0=; b=T/s6UHogHjZzF2Mxez9
	MopXM7w53onpzj5R3wcWtXRLvIFMP3UKodnw7Maq3RzxsBAOpvoBppLpdKfNunXR
	qgn+2X5QOMDCfeiqyp9QwdBMKwhj1DA8ojaQCHZen1laaRA75TV4khBYCzeML0Wt
	xsbyByxnhgufoQwmlJBfs/HF2yakezuIsxZiyUREDicxulFjJeUIPal5hqhTfS+z
	FzuqksgCEB8wQ0+I7IEP+Ae8Ardd7Ly30CZEQt2vfWwNJaHeMJTmyMi4H8rHNCEb
	p/patcRcIBvnYHxAjDnEXULOyWxxRJS5hTVJUqYb0V7t26r7kimQgvgp8IvW5G+H
	hqw==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3xysgc8e3c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 22:23:38 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 447MNbwp012618
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 7 May 2024 22:23:37 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Tue, 7 May 2024
 15:23:37 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Tue, 7 May 2024 15:23:36 -0700
Subject: [PATCH] nilfs2: fix nilfs_btree_commit_convert_and_insert()
 kernel-doc
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240507-nilfs_btree_convert_and_insert-kdoc-v1-1-bab3514eb753@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAOepOmYC/x3NTQrCMBBA4auUWRuI/THgVURCkk7tYJ3ITCyF0
 rsbXb7N93ZQFEKFa7OD4EpKmWucTw2kOfADDY21obVtbwfrDNMyqY9FEH3KvKIUH3j0xFUq5jn
 mZJwbutSHC7rUQZXeghNt/8vtXjsGRRMlcJp/9kL82cwraEGB4/gCLfFn4ZQAAAA=
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
CC: <linux-nilfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Jeff
 Johnson" <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.13.0
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: e8juo70W4WKON-K6wU8jOuA34Lm2N7on
X-Proofpoint-ORIG-GUID: e8juo70W4WKON-K6wU8jOuA34Lm2N7on
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-07_14,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0
 spamscore=0 mlxlogscore=941 mlxscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405010000 definitions=main-2405070157

Fix the following reported by make W=1:

fs/nilfs2/btree.c:1871: warning: Function parameter or struct member 'btree' not described in 'nilfs_btree_convert_and_insert'
fs/nilfs2/btree.c:1871: warning: Excess function parameter 'bmap' description in 'nilfs_btree_convert_and_insert'

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 fs/nilfs2/btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 65659fa0372e..8299839b5129 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1858,7 +1858,7 @@ nilfs_btree_commit_convert_and_insert(struct nilfs_bmap *btree,
 
 /**
  * nilfs_btree_convert_and_insert -
- * @bmap:
+ * @btree: bmap struct of btree
  * @key:
  * @ptr:
  * @keys:

---
base-commit: dd5a440a31fae6e459c0d6271dddd62825505361
change-id: 20240507-nilfs_btree_convert_and_insert-kdoc-7753c4a6e7c3

