Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B2DBA21
	for <linux-nilfs@vger.kernel.org>; Thu,  8 Jan 2026 04:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767845048; cv=fail; b=bgmtHtRf/eLEBOUnaBu/lLeZjgY2MeqPkk2c2FN9puRB9dTM3kYYKjWNidV97RZoaN6DYmhOcWzqYWW1uXhrJ3vDD38pP5jeVpvqiKef5Xbht7yq1pVHq/wcO9DjPSczNQh0+Xsz2zSNwNyNbuR88vqvdK0tqTYbwJJLPob6kp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767845048; c=relaxed/simple;
	bh=88KPUO3CNS88jFNmrK72EE9ZXwLqgB7pq7rQm55kjew=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=QlgzsOCEpt+pnGO/OMJXQf5QnULxO3ql7+3L7TuxBB1ONVpIB2NcuZ+arFB1p1EdqXeD+/ymc0P65f/dI5tFbpkEhZhn1m8iKtosjA39adr1atZ+b7TVuKhifL4Qm2L3jPxF7/o09llvj/we1fHRIerGAZERX09hn3aOy9cYfXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IjmBHwkC; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IjmBHwkC"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 607GmBDi018680;
	Thu, 8 Jan 2026 04:03:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=pp1; bh=88KPUO3CNS88jFNmr
	K72EE9ZXwLqgB7pq7rQm55kjew=; b=IjmBHwkC5WzejvDgcevU7+0kZOKY4eAeO
	IJNBD3482O561vawOx1CWvVxmJ5EVIN+UJAUnoSdy6kAKCWi8seHswmxLrveebud
	NsGhNsTknIHfBQHg2pb/6B5VXBoeW83kV1nFtWqzrO+QxjR2DT3JkpkwcJFdNVZ9
	S+L6WLmx+u9fbNm6yaBUR4wx4cv8vB9gKI7gAodxgNOF80h9O217XNJiGugMGERY
	Royp5FCCYXP2WkvYk4qDyxCh71AZUH+tEoYLjkfEAvpMW94JEE6ROZn9QBudA5Sq
	0kehEMTJLOYKp2Bm98nTAzo8gad0e8ImErKfRtycjTqrFuTtEVJvg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betu6cbvd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Jan 2026 04:03:59 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60843whl021464;
	Thu, 8 Jan 2026 04:03:58 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013057.outbound.protection.outlook.com [40.93.196.57])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betu6cbva-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Jan 2026 04:03:58 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gWQ4bIAaC8k0J84VK1IitTAuTF7ROI588pQSXuOhYQhIOoHpRnuoc/ji83c6UVc1NI9yCWKEqtPu3XI4F6x+T1bbIKD499bkOI5HJD1VDgeqNASOVrDV588XCVaiW9GTayxUzob6FkkKkdLekOcs3yTUFmduOC72TJ5m1jywJb7YmyP92yt0bgd/CMuV5muwV3nrN3vT2LAsjXPEWZx1d8FcXtEbUXG5+OMDWa7loBiV8DOpFiXdYkglOtoz5nIQOhhDuKyH4JRTgi+ux7wbvudbMSyUbJnRufogIHP1GT3YTejkPcQd/WhJEoteVbf6iYF8CiUnL7UZ8tBxTMynwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=88KPUO3CNS88jFNmrK72EE9ZXwLqgB7pq7rQm55kjew=;
 b=o9Opc3XvZTRUfrlTa+uxPqTxQztF0qXZgkQFusgIGjMEKQqlPibF6UIDfIkOwULVokrvSDAmVmXXCyxd0FAPg/TJOlUtSV3BmgnzX06mNcpz4BH/6z33MQMjw7axCG0f8HjaNMwVdJfehd5ZYp0jqqzx5i6YRs+I0703AEz/SC9cFIE8rEc4OTg/F78XukwhhWaB9duqPVLo9b/yvBoyZQr1SOnpQCsEAobK5gYzdiSCyBe3UfpqreVIvI2ZLvNzxNQGiFq7RZ834yhP/li0Z+pdQtNsw6CSAo9EPRYgAK9Y5DMLNkFTdr6UArFLtYG+QJbLs1IT3/p4Sm1cNooDPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SJ0PR15MB4584.namprd15.prod.outlook.com (2603:10b6:a03:37a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 04:03:55 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9499.001; Thu, 8 Jan 2026
 04:03:55 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "konishi.ryusuke@gmail.com" <konishi.ryusuke@gmail.com>
CC: "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
        "slava@dubeyko.com" <slava@dubeyko.com>
Subject: [RFC] generic/003 xfstests failure details
Thread-Topic: [RFC] generic/003 xfstests failure details
Thread-Index: AQHcgFPOFYKtpyPNIku2OF7ix7+eSg==
Date: Thu, 8 Jan 2026 04:03:55 +0000
Message-ID: <93c5c0a639a31958876739641fae9989afe8bb26.camel@ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SJ0PR15MB4584:EE_
x-ms-office365-filtering-correlation-id: f40319e3-9c92-41eb-b30c-08de4e6af174
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|10070799003|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?dXArS3A1NW1COTVLb0JSWWdpQUx2SStZRzNaeWJRbE5XY2diN3lyRi9sOXVs?=
 =?utf-8?B?SkRQanlKblpQcWIwR09FS25qNU95UUQ2RXVVQXNhZlZXTEJNNXVBY05nRml5?=
 =?utf-8?B?L1U4Y3gxTThyejZ3OWN4R01BUHpTV1JaTUhEa0J6TktrSDBJZ3pJQlcwMUdO?=
 =?utf-8?B?WmtRQkpyWWZIczAyUzJNWWY0T0FJWHIrVHIxbmtMeVZ4bFhKM29lMHA2YU45?=
 =?utf-8?B?SW5MWGxQVGJyZXlGWmRQaTV6WVVPd1dJank5dkJ3NXB5WFArSXpDd1RPbHJ2?=
 =?utf-8?B?SXREZTV3ZHVwd2V6dDJmMmVxUU9QQkgwUVFDb3cvZ1lxS1ppMkhyQm45d2d5?=
 =?utf-8?B?SnJOQTlmZnVQNTNoOTMrWTZ3UlJONzRuU2V0THNhd1JSaGNSVk4vZ2dvb3Rz?=
 =?utf-8?B?RHpMMTFQSEFnZ21nME1hYUVObEwrNFUyeVV4amRNTnVxNFFqYzIwMFhVWnM1?=
 =?utf-8?B?bUhrMG5kVmM5YlVzZ0Y4N1BiekJGWTZ0OE12WEQyUzNsR1h0MW1jMDhodlBU?=
 =?utf-8?B?aktEUXhVNXNWUHh5cytOa3MvaGlUU3NBbGphU25uQUFXcENvMjJ6VnlWSzFt?=
 =?utf-8?B?UmJpNUtDSTNlZzV4ZDNGdUZVZDdwSHlQT0l4SXY4NlVWbExVYi84d011dXpt?=
 =?utf-8?B?UVJWRGc2L0VhMmN0TUkrWEYzS3BOcEVLWWlqZlNWRmUrZ09NU1A4ZXNDTmRn?=
 =?utf-8?B?Zks3OWhienNMdnRoaXpLREdpcDlKM1QxK2NDY3p4NEcvUUJQc1U4TFhybFpu?=
 =?utf-8?B?Qm1va1c0Mmp1OTNaUTVYenl5b0JndXY4dWtGaElEdzdIejRLWjZzcCsrZ0kz?=
 =?utf-8?B?MVBWNldZaHp6QWxPc2NiWktLRERuRXdOVlo0c1JOWHZVVU1qdk52TGFFWFBu?=
 =?utf-8?B?V3VDb2txczdmYzN6NWhWOFhiZGdoRkRkSElhVXVrK0xqdk90eWpqR2UvWk1P?=
 =?utf-8?B?aWJpbGppWGZrVEhxdE9Fc3dqY0pUYkt5cVlPMnBEQ0l0NnRqWE9FYitUZ0ZY?=
 =?utf-8?B?UTI5UTJTaVNIdDJEcmtSaUVTVEVDcTYvUkNNdXJSTDl4MzVvTWVuYTVKWVdu?=
 =?utf-8?B?ZDc0cjdPdWRpckZabXJiM1lYdnhtTko5VkMwaGdwUjFjK3RxSTFEQ1VYODUy?=
 =?utf-8?B?N2tlcGFsRXMxRTk0dXpERDFja2xkUmtVaTVhRVVwWE1IL2dsZlV6dW8zUHpS?=
 =?utf-8?B?NHVLeHN0N253eGZnOW05LzE1NENmZENBQS9xT1dTUGlXVEhBSmhLNEJTc3NS?=
 =?utf-8?B?WlhwUm9pQkdzeXZXL2Z6RGJlSUQvTnY4cUVQejlqS1FwSkY3bDZuOW1ydEZE?=
 =?utf-8?B?aUY2aWZCUFlZc0Rhc3hSM2NCS3lha2JwY0ZzcjdxNUxxb0E3ay9RQmFUMnZr?=
 =?utf-8?B?Q283UkdVSTYyYTJFSitUQU92d0dRZFljNlRZek5menN6NjNXa1dRQnRoK283?=
 =?utf-8?B?NVVFQnZQNEd2Qjd4anhZNS9yc29HU0tNMmJFMjJ4T0FNVnNvejVkNlUzcDZs?=
 =?utf-8?B?bVNPdUU2QktqTHhEMmtCZlRoSUE3dkZOSHpzazU3b3dsQkFJQmVzTDU2MjhO?=
 =?utf-8?B?NU5CMG5zY2JwNDNPUTZORXJRZ25CdkZma1RVZFhMYkxwZktVVUFOc2pZWTlu?=
 =?utf-8?B?c3YyQi94bzFHMzYxTHVaNXVQbFNBMWZLMklXWk9HRGxWMDE5eXFPcVh5ZUlZ?=
 =?utf-8?B?Z0l0SlFud2c1dHVlS2Z6c3pBNFRqbnVwYUszemljL29pSWVCRWN2cEY1TDRC?=
 =?utf-8?B?ZkUwUDdRSUtDblo5eE9RYWhtVTVsUHJndTl0MjBSVXF6K1lTdko0S3c4alpE?=
 =?utf-8?B?cnF2ZW9XdXc0TC8zQ0Q5aDVRS2xNS0hIZjdGNkFnbUNXcmxKQUFRaWtvZzg1?=
 =?utf-8?B?Z2VwNlVwN1lKSjQ3SzhlOG1QdmxnRTF0bXdLK2hkK0dZUG9uczQzcUJDZndW?=
 =?utf-8?B?Ly8ySXNPZUZzM3JLdHlDQldxbFNPb0Q5WEVLMm95enJFYXFxaGNIMzh6azNX?=
 =?utf-8?B?bGxnbDFYWWdRPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(10070799003)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?a2NYMzdPZnhJQlR5VGEwaUtQUEJsSGlNUG5vbVhzdm1YWmtVbVFYS1VjYm5X?=
 =?utf-8?B?TnorUEltcXVCbml0MjgyNXNCVkZRSjMxTVhvN3dHOUlTbWVlTE9NS0l6YS8y?=
 =?utf-8?B?WXdCd3NTL3lsZkxoQWhoYXJNbUI0RkVPajMwV2gxNVBXWW8zL1JtcGcyVWU1?=
 =?utf-8?B?R0IyZ0k4UDdZZDB4Sk5QQW1ybHZVRHY3bEtWWHpPaDVUdm5lc3VhT2FvWFNW?=
 =?utf-8?B?QzJvS1dtcndDaVp5S2htZFBSdE40dGZJNUFXMnlsNXlYaGRNM1FqaUxqM01h?=
 =?utf-8?B?K2diaEZXVHo4WVduRndQaXJVdmlUTlN2QVp3ZnJLU0d6NW40VERTYlNCbGMx?=
 =?utf-8?B?Z2pFZ1VuM3M4VlY3eXF0WHo1NS9ZTFRFMGVGdHcrTEp2ZTBHTWRDaTM4WnRl?=
 =?utf-8?B?QndmOVZLbXJqYkl1UHBZOEdpa0IyQzhoU3k4MENoVUs2QzJDd0o2UU13V1h0?=
 =?utf-8?B?V3dRMW5rQ1E3ZFFwcHNKRkZERzFrQTlnRFpLNkRTNFNLbVhrRFJ5TXpxVGdW?=
 =?utf-8?B?eUZocjlaMjhaSXVTS3JFZzBNQkhacmhJaitIeEpjRkJyaUMzUDlFVjN2ZnEy?=
 =?utf-8?B?SjRzVjNMRURuOVkxdUh6RlZjMyt4RWZQWWE1WE1tcVJsRER5bDBuQUxnYkhU?=
 =?utf-8?B?Z1JVcUswL1AwckM1cllubU9sY0F1cUVqTU5rdTFyK3BYUG1nQ2NKSVI3Mmkr?=
 =?utf-8?B?UGF4bTMvdERqbnRyUnpxcWlEOTZVeGxlb1RkakZrRGlObVkvUTd3VDMxMVJw?=
 =?utf-8?B?QlhqekUwaER3QmJVOVFZR25IZWdFQUJ1ZlZmNnEvcXBUaC9xL21tNTFGWUhj?=
 =?utf-8?B?T0NWOTJoUWUxTklDWXBNaFBDWnZTQXFZbmY2eEI4T00xeXVNRTlWT1pCMjRR?=
 =?utf-8?B?dkpBS25PMnZlZnV3N1RuajJDWGdFbkptSUhVSm44dW55Vk81MEZSL3VHdmY0?=
 =?utf-8?B?NU1pSGVEczcrNWVCa21Nb1lSVkRmUnE5Ykh1MnlneS82ZFY3Rk04UjJLZ3Fj?=
 =?utf-8?B?Y3BRdnpGcnFjdlhVUC95RGtKKy9wQm1UaUlxcURacXBtNDNMR2N0QUNXMlk0?=
 =?utf-8?B?TVJpNU1rUnVTYUl2V0ljN2l0ejNPc0l0d0dGaGtHZ0J5eFE4dkFGUlVyTmJi?=
 =?utf-8?B?V1lDR00yWm1RTHJaSDhOMzg1NnJob2hPUnJSb29xL0txVjUzMDlDTkw5SzI5?=
 =?utf-8?B?dFFqUWFRb0k5R2ZDMTcxaDlWUnZYdnRCRnpxYmVOd2VhaXJ3VHBZYWE5QlRZ?=
 =?utf-8?B?SEdNWlpJMkV4enFtU1U5KzQ2MU9QRW8wN29rTEhoeDI3K1JURGtCMlBVTS9x?=
 =?utf-8?B?dDcrNWtqM0JBV2E3cDRhMzFzRU5YUGRxcTMyaUthak5tVkpLY2JWVkRvM2U0?=
 =?utf-8?B?RGkxWENkTnErYnkzZHY5VWNYOXhIVmFaTUJGTW8vZGp1UzRET0xONTlZRXZB?=
 =?utf-8?B?RTdzMkQ0RDY0NFlDeldTQUxsR01VV2FrK28rRXp3WU8zUG5rR3ZQd1dMNlJy?=
 =?utf-8?B?QmgwSzVoTU9SaDBpK2lxK293T2MwY3RyNTBvWkdtREhpMkp3TjVER2Mwam9W?=
 =?utf-8?B?RVVOYWhOSFB1VjRDSXF5RDZhYmRjQzJDSUJhSFY5SHcreFBSTEx3SHhoWTdE?=
 =?utf-8?B?bVdhSHcyMjNuTGF0dW9odlpxU2Jkb3JsVUtNcTkvYUFTa2dYRXRhNUhFMnEw?=
 =?utf-8?B?dmJYMXlubk02M0huSjFNWHNwc0tUaWQ5V2w1c1BkdzllKys4M05NUENrMWRs?=
 =?utf-8?B?N3hiNEszZ1pybVJ3U3A4M25WU204K2EvZVBJUmhiMFRQVE03TTJzYkhKbmNZ?=
 =?utf-8?B?cXNicHhJNTlCMGxmZzh2V0dhSlVlbDZ6UEdDdldHY2FiejYwSDlkdld0VFB3?=
 =?utf-8?B?Z2FFZk9WSG5BeUpvTGYwbXZMOEgxWmpRKzlqSHdaT2twaVV1cUU5SENZa3NG?=
 =?utf-8?B?RDVYTGovdGc2cEFMSmlLNEVFZ09wUXdtZytxTE1KZXd0TFI5eXJRZ1dqbDQx?=
 =?utf-8?B?Z1VyUTc4Mm5jUjdieE02K2RPYTZWdCtTa1lOekJoV1VoKzdZSTArYjNLUUNG?=
 =?utf-8?B?NTNhVTdOYjhwZ291WG5BZW5sdkZOSk1uZ29lR0hIRHgzS3NxaUxFWnJKekhn?=
 =?utf-8?B?WUdJU25lRXdobXNLMm1nM09KUW14ZkJxVUVTOEsrWlFLWmMxQTFEYjBaeThp?=
 =?utf-8?B?UUlRYWVaZ3dlcGdTUlNSWFpjenQwekdQMVMyNTJPVC9kbStBMXVHMmhRS2Nm?=
 =?utf-8?B?MitXL1cxK2FpQXAyUFFmeGd3WndGN0tvNk5jUWlFaXJxeFd1cVFsVGZibkEr?=
 =?utf-8?B?VFdyVWFDZTc0NXBoR1V3YytPRnFleFFIMHdaZ01kMGZqTVE3Y0pkNmVBajd2?=
 =?utf-8?Q?GqHyXrLROtgkIFcqlkl57AY9/xHJvKZBG1NoB?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E7F2DF0A14B68F42B847900E58E1F054@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f40319e3-9c92-41eb-b30c-08de4e6af174
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2026 04:03:55.7259
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JIhnuFqg+1YbIeVc1L8djsTsF0vhHVSrK6ZF+dKZuKSyDhvI/75vSMsAJD3b+AJ+td7ObIvA5LK6mYg6V+czzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4584
X-Authority-Analysis: v=2.4 cv=QbNrf8bv c=1 sm=1 tr=0 ts=695f2caf cx=c_pps
 a=u5eD0AXnJOl2BG6obV1kTA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=P-IC7800AAAA:8
 a=nw52K1x1Uf_5gyWWSl4A:9 a=QEXdDO2ut3YA:10 a=d3PnA9EDa4IxuAV0gXij:22
X-Proofpoint-ORIG-GUID: xrjJKGJRkP8Vhn7IOPn5QeGjX8vUqEda
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDAyMyBTYWx0ZWRfX4Ud+cp/BPlRv
 R9VYeW7QOpzSMzTBiOoxHNSGFmpz9r1K6ux8zlnMaJaXn6gdGDU7vZrjV1WZyHF3kKhmYgoDTeO
 GbDAe1htTXnW3KC3F3I21w8GDRUkKmbvnpTb1maa0dhWWB/lFNBlx9BEodo2GQg47T4yHai1Li2
 LhY2Vgi0iJNFd+VTx6YGxc7IYS2M9XfkejcOpPqNH5SprAIcgiG3nMOkg8ik63Yld+k2WK43yQO
 CQuRhz5x2z8KlsKtj9rvHLoiTytMf9LDcpqRA1f7/roP5Kb1o11dLybeJEYbC18BAcSGJFsGkYX
 4wcO6PS9rQSS/txC4JDrPRwqR5w9wLT+3ksTbQi6pDqWYM0aK23hi1L0F980YV6ZlzJxqZ8HKku
 zr/W2DFuyjlbhPN7MwHjlSHxSxHXCEPWwDClTjgHYLzj6QiyZ4AV7MOYem78txkwgukQWt5vuB6
 fR7SmAeHh9eo23w71AA==
X-Proofpoint-GUID: YcHEZKT5D2IAIlDU17c-ptSB656BQ-SG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-07_05,2026-01-07_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 bulkscore=0 suspectscore=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601080023

SGkgUnl1c3VrZSwNCg0KQXMgZmFyIGFzIEkgY2FuIHNlZSwgdGhpcyB0ZXN0IGlzIHRyeWluZyB0
byBjaGVjayB0aGUgYWNjZXNzIHRpbWUgKGF0aW1lKSBhZnRlcg0KZXZlcnkgdG91Y2guIEFuZCBp
dCBleHBlY3RzIHRvIHNlZSB0aGUgZGlmZmVyZW5jZSBiZXR3ZWVuIGF0aW1lIGFuZCBjdGltZS4g
QnV0DQppdCBjYW5ub3Qgc2VlIHRoZSBkaWZmZXJlbmNlOg0KDQpzdWRvIHRvdWNoIC4vMDAxLnR4
dA0Kc3VkbyBzdGF0IC4vMDAxLnR4dCANCiAgRmlsZTogLi8wMDEudHh0DQogIFNpemU6IDAgICAg
ICAgICAJQmxvY2tzOiAwICAgICAgICAgIElPIEJsb2NrOiA0MDk2ICAgcmVndWxhciBlbXB0eSBm
aWxlDQpEZXZpY2U6IDcsNTAJSW5vZGU6IDEyICAgICAgICAgIExpbmtzOiAxDQpBY2Nlc3M6ICgw
NjQ0Ly1ydy1yLS1yLS0pICBVaWQ6ICggICAgMC8gICAgcm9vdCkgICBHaWQ6ICggICAgMC8gICAg
cm9vdCkNCkFjY2VzczogMjAyNi0wMS0wNiAxNjoyMzoxOC4zMTU2MzczMTMgLTA4MDANCk1vZGlm
eTogMjAyNi0wMS0wNiAxNjoyMzoxOC4zMTU2MzczMTMgLTA4MDANCkNoYW5nZTogMjAyNi0wMS0w
NiAxNjoyMzoxOC4zMTU2MzczMTMgLTA4MDANCiBCaXJ0aDogLQ0KDQpzdWRvIHRvdWNoIC4vMDAx
LnR4dA0Kc3VkbyBzdGF0IC4vMDAxLnR4dCANCiAgRmlsZTogLi8wMDEudHh0DQogIFNpemU6IDAg
ICAgICAgICAJQmxvY2tzOiAwICAgICAgICAgIElPIEJsb2NrOiA0MDk2ICAgcmVndWxhciBlbXB0
eSBmaWxlDQpEZXZpY2U6IDcsNTAJSW5vZGU6IDEyICAgICAgICAgIExpbmtzOiAxDQpBY2Nlc3M6
ICgwNjQ0Ly1ydy1yLS1yLS0pICBVaWQ6ICggICAgMC8gICAgcm9vdCkgICBHaWQ6ICggICAgMC8g
ICAgcm9vdCkNCkFjY2VzczogMjAyNi0wMS0wNiAxNjoyMzo0NC41MzU5MzM4NDMgLTA4MDANCk1v
ZGlmeTogMjAyNi0wMS0wNiAxNjoyMzo0NC41MzU5MzM4NDMgLTA4MDANCkNoYW5nZTogMjAyNi0w
MS0wNiAxNjoyMzo0NC41MzU5MzM4NDMgLTA4MDANCiBCaXJ0aDogLQ0KDQpNb3Jlb3ZlciwgTklM
RlMyIGhhc24ndCBhdGltZSBzdXBwb3J0IGluIG9uLWRpc2sgbGF5b3V0IFsxXToNCg0Kc3RydWN0
IG5pbGZzX2lub2RlIHsNCglfX2xlNjQJaV9ibG9ja3M7DQoJX19sZTY0CWlfc2l6ZTsNCglfX2xl
NjQJaV9jdGltZTsNCglfX2xlNjQJaV9tdGltZTsNCglfX2xlMzIJaV9jdGltZV9uc2VjOw0KCV9f
bGUzMglpX210aW1lX25zZWM7DQoJX19sZTMyCWlfdWlkOw0KCV9fbGUzMglpX2dpZDsNCglfX2xl
MTYJaV9tb2RlOw0KCV9fbGUxNglpX2xpbmtzX2NvdW50Ow0KCV9fbGUzMglpX2ZsYWdzOw0KCV9f
bGU2NAlpX2JtYXBbTklMRlNfSU5PREVfQk1BUF9TSVpFXTsNCiNkZWZpbmUgaV9kZXZpY2VfY29k
ZQlpX2JtYXBbMF0NCglfX2xlNjQJaV94YXR0cjsNCglfX2xlMzIJaV9nZW5lcmF0aW9uOw0KCV9f
bGUzMglpX3BhZDsNCn07DQoNCkN1cnJlbnQgaW1wbGVtZW50YXRpb24gZG9lcyBzdWNoIHRyaWNr
IFsyXToNCg0KaW50IG5pbGZzX3JlYWRfaW5vZGVfY29tbW9uKHN0cnVjdCBpbm9kZSAqaW5vZGUs
DQoJCQkgICAgc3RydWN0IG5pbGZzX2lub2RlICpyYXdfaW5vZGUpDQp7DQo8c2tpcHBlZD4NCglp
bm9kZV9zZXRfYXRpbWUoaW5vZGUsIGxlNjRfdG9fY3B1KHJhd19pbm9kZS0+aV9tdGltZSksDQoJ
CQlsZTMyX3RvX2NwdShyYXdfaW5vZGUtPmlfbXRpbWVfbnNlYykpOw0KCWlub2RlX3NldF9jdGlt
ZShpbm9kZSwgbGU2NF90b19jcHUocmF3X2lub2RlLT5pX2N0aW1lKSwNCgkJCWxlMzJfdG9fY3B1
KHJhd19pbm9kZS0+aV9jdGltZV9uc2VjKSk7DQoJaW5vZGVfc2V0X210aW1lKGlub2RlLCBsZTY0
X3RvX2NwdShyYXdfaW5vZGUtPmlfbXRpbWUpLA0KCQkJbGUzMl90b19jcHUocmF3X2lub2RlLT5p
X210aW1lX25zZWMpKTsNCjxza2lwcGVkPg0KfQ0KDQpJIHRoaW5rIHdlIGNhbiB1c2UgaV94YXR0
ciBhbmQgaV9wYWQgZmllbGRzIG9mIHN0cnVjdCBuaWxmc19pbm9kZSB0byBpbXBsZW1lbnQNCmF0
aW1lIHN1cHBvcnQuIE5JTEZTMiBoYXNuJ3QgeGF0dHJzIHN1cHBvcnQgYW5kLCBhbnl3YXksIGlf
eGF0dHIgaXMgbm90IGVub3VnaA0KdG8gaW1wbGVtZW50IHRoaXMgc3VwcG9ydC4NCg0KV2hhdCBk
byB5b3UgdGhpbms/DQoNClRoYW5rcywNClNsYXZhLg0KDQpbMV0NCmh0dHBzOi8vZWxpeGlyLmJv
b3RsaW4uY29tL2xpbnV4L3Y2LjE5LXJjNC9zb3VyY2UvaW5jbHVkZS91YXBpL2xpbnV4L25pbGZz
Ml9vbmRpc2suaCNMMzcNClsyXSBodHRwczovL2VsaXhpci5ib290bGluLmNvbS9saW51eC92Ni4x
OS1yYzQvc291cmNlL2ZzL25pbGZzMi9pbm9kZS5jI0w0MTMNCg0K
