Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CE91096F
	for <linux-nilfs@vger.kernel.org>; Wed, 26 Nov 2025 22:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764196995; cv=fail; b=TH2UumfWo2vyHd9z0ma2PdjEuJo8zRztU0DMj5AdUldVvqjmQYLY4WjXkr6HouhjF+qn571qQERcb9KJXcNcIlpeYwo3ysWAkt97GISKFCuXXaQUL72ZYivnXevNaymhgczbay6lPMNFdoNL8K7UijDmmxL3/4aEZdDh/58y08o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764196995; c=relaxed/simple;
	bh=ZV2aWzkKVM6e0NQoKf+uyAJwl0uufUA2P6tjWoVyI7E=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=XpPNDMUlLAltylvrGgP6F4Ky5EgpFNjf+6HRqqhx0K2c4ldqPA8f2sSf2iYGfLExIsTpltA6rZQGq4QP+NZ+xevqvuT5EpyAabr+24Yp4sAEU0Q38Ly//3Kgk/dDukl3zkwQ8suPBQPuZ6uG87ADUixs9v0LNRZXozJp1Uyyqb8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bGfKzzDS; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bGfKzzDS"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQCK36i030743
	for <linux-nilfs@vger.kernel.org>; Wed, 26 Nov 2025 22:43:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=0O9S4/CJLJzfs0T/Hwn/wfU8QjP1Rs6F62CIgavdk2g=; b=bGfKzzDS
	CN5LdPLZ4Fiw4uFO0swJ9fcALBkyInDohpimunbgFs3IJAuycqlOZOaWx70oXSR5
	pKJ4JH/z0Rz02BuRp+N75UjIzv6JthEBoYp5vpvZb3ubK/VcbxUBD0YKl103PKXh
	MU8TBl6z8Ch2Irwh1wn4kcjUFGfh8vYwKdM6kwftPMgPVuC0XNhYBbJEMr18+HV/
	sHu+toVZVEss5Wg2DLY2h4PlF1ybx1KfmLYY/ONLhwl6OX5RIDw/ifzJGja7ms2X
	+X6jp6M+Ory8se1aGExWRXJPbW5XBPBC2roNnQYpn/YQMAe3lc5ZDj9DmT8hYnHD
	cydtNGMivrOvHw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4pj6ty9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-nilfs@vger.kernel.org>; Wed, 26 Nov 2025 22:43:10 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AQMhA7G026943;
	Wed, 26 Nov 2025 22:43:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4pj6ty6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 22:43:09 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AQMh9oD026937;
	Wed, 26 Nov 2025 22:43:09 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012025.outbound.protection.outlook.com [52.101.43.25])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4pj6ty5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 22:43:09 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Im5YlqbqDhKFxEoq26M8/SgMBIieaWD1psZwPWEnKp/NlU/9ksVH39NWz7lxjX3lx0tEmYhGotZdMmUdL0r75Z7rK9NUX0qhiOurfV4y66fVEptACDJOFp/1HSnI2Km3nOAn4Keb/7JdTDLRgHzO4cAqi0MhZ5DcsGL37019H+sMz4PqzQiG8x494xewPv2nStf/sThEQQQnlJwrxJmea01aX8tbEs97E1/aMg+An5PYUX593BDeREMevXXs4i4Pjj0v17OLQF44MGYnU+jktrSwNccBkkWQlzqFr4qdq404cOuqmY2CJf/ZNIuJZcQlxvFHiNxNoWDXjNxSRnHefw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jthk26Yvgm+7D9kGdXA2d2L/GPI8haVVaO4YJjG1bxY=;
 b=rPfZz+gHsX7JoeZiBxG9rjsIfHjYC+kEveHAQT9oqzKqjTmC9mA1YYDaLKqM0KPrujrRgS4DNWldtv/WNHlw81n9bhnGAZAYtWebc73YubCVxRPllGNwDXE1PC92/XwPzglIDlXNpgSnvTlLNIz9jFmz8inMuCOnbzamZjVVJpflgtUF/edYJ4F4J70pThioZmENIz9VTwY51z6bbnzRYf3pC9nSQkS+cB0iCnRx1VHwhUN45UXCdV/nXuO0JxLF7WJUVlarg9UkalroZf2We0Owwz6IhsHNxte8nnzIKXfWwMYVx5fJt2Wc0uzihS+XDBSz/88HgUkARHoc8k36AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by DM6PR15MB3989.namprd15.prod.outlook.com (2603:10b6:5:294::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.13; Wed, 26 Nov
 2025 22:43:07 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 22:43:06 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "konishi.ryusuke@gmail.com" <konishi.ryusuke@gmail.com>
CC: "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
        "slava@dubeyko.com" <slava@dubeyko.com>
Thread-Topic: [EXTERNAL] Re: Status of running xfstests for NILFS2
Thread-Index:
 AQHcVPxMvOR0TznASUaKKmt1+Qe6frTz45oAgAU3GQCABB6UgIAFFJ6AgAKxfgCAAKKygA==
Date: Wed, 26 Nov 2025 22:43:06 +0000
Message-ID: <6b77c17169a39f75f4731073b3315df25f706e82.camel@ibm.com>
References: <ad4826a48dba37fee0fa9949bfdeef8747ab8e93.camel@ibm.com>
	 <CAKFNMok6sj9EPgCBSn=3Uc1ze51jbPH69xEXQtFTej3B1JcTLQ@mail.gmail.com>
	 <66926bf9a9cb9488dd5f8fe9493d366fb3fd7e66.camel@ibm.com>
	 <CAKFNMokvQpOS6KcyxKjHs9bQ7a6Oi37EaaMD+0Vp3xE6HuYOkA@mail.gmail.com>
	 <c2b125c3f1a2b792241800c3fa7b6d6b56450add.camel@ibm.com>
	 <CAKFNMomX4eBT2xFyK3XpK86ghEyB=ZGsLZr7H2C_xqm7Ysusyw@mail.gmail.com>
In-Reply-To:
 <CAKFNMomX4eBT2xFyK3XpK86ghEyB=ZGsLZr7H2C_xqm7Ysusyw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|DM6PR15MB3989:EE_
x-ms-office365-filtering-correlation-id: c4919604-d7df-4cb4-ecdb-08de2d3d2ac4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|10070799003|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?TEVzRVB0c1hXSVF4Z1pTdmhJOXNrQUJpSitFSEN1NmM4TEtESHd5WE4yZVFy?=
 =?utf-8?B?clpNcVJLQ1RrcTVzYkZVWjJKNmVzSWQzQ1JVL0ptKzNDSXRIWGdxVzhORUFJ?=
 =?utf-8?B?c0FGWVNVVkljV1Z3VVJkVUxicnNjTDlRL3g5clNmeVY2dVFGWElGdDZjSkpH?=
 =?utf-8?B?ZjNXaVdyY0NNeC9sWFJYaEdWcXBxRjZZWFd6ajJoQlVyS2lhR3ZOSHFNN1dR?=
 =?utf-8?B?bDhsNDY4czNZMnM2NVU5WXRsZ0YvMHYycElNNWdhbnVnV04wdzJxU1FTeHho?=
 =?utf-8?B?VmM2S0xYekl3cTRORVpNOStZbldmQ2UrU2F6VE9EcW56S05tc0MvOFVFeXVj?=
 =?utf-8?B?SEJjRC9NUkEyMS9ReHlvM0VkcURvakN1SUV2NExyRnFyYnlnWURydXFBM0ly?=
 =?utf-8?B?b21yajR3eHNBV3h1RFYvcXU3QzhnL0VJcldJTkU2ZnRiN2Z5M0NZTUpEMnI1?=
 =?utf-8?B?NksvZWR0SjVHOVFzdkovZExjYTV2NklFVlFQa0MzKytLZm9JaFVvbFZuQnFq?=
 =?utf-8?B?OHhjRXVhblloQVFwVTdwUjZiQ1A1blJCanNDMGRQU3RuV2JWUjNyWlM1bFZP?=
 =?utf-8?B?ejFoV3J5OVVEb25NcnREY3NiVVFEZXVrR1ovZE1OY2gvMHk4U01TczRvYnRC?=
 =?utf-8?B?Qm0zZUg5VmptTE0xbkx4eHhqZTM2VWJDNHZ3cC9JcHhhMXlKUndZb09QTWEr?=
 =?utf-8?B?RVRwc2pMY2gxNHU4c3Y4SHFSbUU2U1crRFJCR2dXcjgvVW54OElkbVNCMENo?=
 =?utf-8?B?WmQrVnhqaFE0K1BuVmllUHNLZVlEMWRTaFVGQ1BtWnh3bmhDTTUzQjhRcmxi?=
 =?utf-8?B?ZzY1dXNsNVM1VE1sRXVkQkNkZ0Z3aGhua2hhWlZlU1RJV05TWTNzRjh0bnlE?=
 =?utf-8?B?QnNqK3NtVFNrdFVSMTdZT0w2SEdiK29zSVNJUmkzalUxa0VZNXJTWjBlNzl3?=
 =?utf-8?B?MTBSNkVKaUpQMHhxQnFXTGs2OS9XenZVTVRlQ29qYTdnSyt4Z0ZDZjNZT0hH?=
 =?utf-8?B?MWNtT1BPalpmK3UrSGE5dkEzRkl5dE92RTQzM0dvWjRVTnhaU3YxakxYMW9m?=
 =?utf-8?B?aWhXSTAyZEUyUCtFTEtvN0N2R1FSbnprOGZjaVVLQkVuRlJMNFRjYlgyUEtT?=
 =?utf-8?B?eWlZaGJIWlBXUk5FeXJwekZvK2dVVDJaSUFLVGY3T2R5K3JRN3RuOVRXZWFE?=
 =?utf-8?B?ckl0SFpvYUh3Vm9CNXR1WnFHZ0RjTVY0Z3RPY0ZJRjhWMWxIUGpjQTVpbjZX?=
 =?utf-8?B?QUxwNU1mcEFqVlkyWVVXM2ZKU0hhQXZveHltOGtDR3JYSjJTNmZ6c2JVVlhi?=
 =?utf-8?B?eWZMWjRSZkRXTEl0ay9Ed0RhM3NsNDgxUDBJWk4zM0ptakFZeEVURXVXYkdD?=
 =?utf-8?B?Slk3S29DRlpkZFlQaXhJTDNEOHZqZEZ2T2ErZGFJNGxDcjhPNkZOb1k5NGtr?=
 =?utf-8?B?K0QveUFiRkZ0VWl1a2szaVBMano0Rll3TG9lcU5LQVJGVTdPOHdPL2NIR0FK?=
 =?utf-8?B?Q0FMV2g3bm0rYmJmOVpiSjFhRHFLVGhzNFdncm9xdzV0UTVSYXZ6enJpSmg2?=
 =?utf-8?B?Mkx4NVllNWh4OXpqNEZLSW1xK3FuRVdCblJiQ28vclZmdWFNZHVlQys3Vm8w?=
 =?utf-8?B?ZVBKb2ZJQ2luM0hLS3BWNTdZZVVmeCtxSGJwZ0ZWYU9oVTFXUHl4TmQ1WWtO?=
 =?utf-8?B?THlWRWVtbmNhOUo4dDlTMVZGTHdRaVlkTEVBUHNzQWpsMVV2bXJPSEJQUDAy?=
 =?utf-8?B?emhwNUhWMlhhd0VQSnJCNTRPOC9hVkgwWCtWczZESWVIUU01SHh1SitPVVU1?=
 =?utf-8?B?d0VnTWxBRElkSlBKTnl2QjRzcTJ6LzNvQzN4eG9LZk1CT2Vna1V3RHhhQzRP?=
 =?utf-8?B?NW1HR241SlJlNTVsOU9sTElXc05QTm5KNWZDRnZ4VFBIVEl0ZTJTbTJyRHVR?=
 =?utf-8?B?L212TDRTWHBUWHlmRWhXM0VaYU5MYytlRnA3bStxSlJyaDhuZE9Xc1IwR1Qx?=
 =?utf-8?B?REVtTXc0Q2dsTTlBWEdkdnBFdjVhNnIzRXVkMVNVWWt1Z2ZhNEVhLzRvVVpD?=
 =?utf-8?Q?Z70fPe?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(10070799003)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dUN2eHVZdFloV2h2M3hGV2VQbWp1UzIzd0RwS2lWakFSeGdZdFRWWjlsOFl4?=
 =?utf-8?B?bVUrbm9VMTRFVHp0a2k3ZDY1SDFQMURYZmJuNS9pczNlLzVhdEVWcTFHVzhH?=
 =?utf-8?B?eVN5dnpKRmV1QzhhNXQyYzZrZFFGM1BpVTRyYjVQWVRwZCtkekRKZmJHZko1?=
 =?utf-8?B?SmlrRk5zL3pRSnNveHJlTXJ1NXpwdXl5a280VytkYnJXcGVuWnp5SFZ5Snox?=
 =?utf-8?B?ZmtxVHdmM1RQRHI5NFZnTjZCa3l3dGQ2V2dnSUlJa1RJbnovZDlZY0Nhbjl1?=
 =?utf-8?B?MkgvdC92ajBrZWh2WlJLOUljTmorNDRUUTJFK0pnbzlJeCtCR0RESzlETHJk?=
 =?utf-8?B?Z0ZZS0JlaVg1eVpXZVZScDdGMitRaFplSDl4U0RVN1NTVmNpdmZBK2RjeFlW?=
 =?utf-8?B?ODV2d1hMQjliTndJcDlENldjRE5wdHJsUEFveUFncnVHQ0Qzc09pdjU0YSsw?=
 =?utf-8?B?OE1DbXJjSXNtamxncHd4RVovazRwNEFzWUFEY1E2dzRvamFQZnNqMm5OeHpX?=
 =?utf-8?B?MzFFclFUOGo3ckpTbk9wYVUvSlhMZzJPa1o4aUw3dFJ6dXE2UC9KZWtESjN0?=
 =?utf-8?B?TFdBeVhQdDJvTmQ2K3YxaStvQm5iWm9rS3FpR3JUaVJ0NVI5RGZ0ZUE2WnFz?=
 =?utf-8?B?c0Z2cGpCVDhBMk1wMzY2b1pHOHhpRnJEQ0oza3JDcnFWTlpNSlJsSUg5c1J6?=
 =?utf-8?B?QlB2OVZ4T041NG9hRGl6ZW9tdXFJd2dBL05JcmVaMU5WOXFvN0lMYllkWVBa?=
 =?utf-8?B?SzRBalM4UWM1cUtmbkFKT1hNQWtRaUF3T1hGeTQ4TnlPdUgxV09pNXRCcHhJ?=
 =?utf-8?B?TEZvelJNSlovZ1pGY04xZlVyamhWNU1NTE55ZnJxNTFFNlFJNjYwMTFnMW9T?=
 =?utf-8?B?aEZLSUJsUmozVjFuZnBNRUVzdXVCaDk5WEUwME5KVE9CeGZXeExQMHJFSjdT?=
 =?utf-8?B?MXlkNWxidVVEVHRyeGlBL1NrZ2IvN1FibnhTZU1qSEpQVU53d3YrNFQ4UGQw?=
 =?utf-8?B?d3RSNklHcW1oQVhyN3duQzdqa3duUXZXRkVBQ0dZQlVwSDY5bUg3Si9sSEFH?=
 =?utf-8?B?NzJrRm92Rk1EcmZjdXpyck5ITXNBaG5YQS9heDhuNWF3NFdBeFNneFBjSWE5?=
 =?utf-8?B?cEc2dVhFWW12UEhITjVQVHFKRnRPZ2VTRUZCVkFvdUNaS2UzaS96QXV6ajJv?=
 =?utf-8?B?enRacC9ucWExTEw2M1dRWTdkWnBqTnJzYUxMQW9xNG05WnQ3Q2E5WGNJbWRy?=
 =?utf-8?B?djVLSlQrR2t4ajdGWCtmWEMwLzltT2NUc0JaS0QyRDkxQnRmaEM0aVlmS0J0?=
 =?utf-8?B?b1lsdURVNDhucG5SQzRhMjl2N1htVFV4bjdEd2JWR3JvdnFDMDJOQTY4SEZP?=
 =?utf-8?B?WDVRc25nUUVNaEFCcUJEbkVFTGYyamtJME9tQWduS3AwSnAwdmRMQno5ejFu?=
 =?utf-8?B?NW16YTRqZCt1Zy9GYkdaaHArOTdlekNoNk8zYzBaTks0RzhUOFZzbXZ5eWRo?=
 =?utf-8?B?V3I3bDBBY2cwQmlvZDIyZE9sV0I0dEpER1dzQ3lyNnVqeVRVdUx6SmVjK1Ru?=
 =?utf-8?B?NVVXeDhXc1FwbVVZSTZkcXRLaldpWWltSFVlc2ZSL0ovY21GUkVPVi9JQjV1?=
 =?utf-8?B?cWVvUEJWS1F5bmZ4dFdpL3hzRmRDSVc4Qm5aZFRhSGZ4NCtvUklqSldzR1M4?=
 =?utf-8?B?d21TR2xwcVVSdGp2U291QjFsYVlJZzZubXZuZXJValR6OWNIZ0owVkcxeFRv?=
 =?utf-8?B?SjFEQjFxbzZMQXdab0lIcVdIbFI3Wkd4OVVaY3dEbnpkWFpHVXdqdWcvellY?=
 =?utf-8?B?TmNqZkVYbWE2U3NFRVc3N1FxZFBOQVB5YXpYZDA1Z2hTTWEvS0U2dmx2Ylc3?=
 =?utf-8?B?dGRUQTZKUGQ3OEhtbFkzMnJBYTU4MGJxd3JGRGszNHkrU3F0RTNmbFM5cDEr?=
 =?utf-8?B?UXM5YmJ5TnhKSGpidi9QZ3U4aENwMnA1QklldVRVZnJXTWYxd1h5S0FXdWhk?=
 =?utf-8?B?WUFCNG5zckVVdHpkNVVMaVRiRkllTTYxbWVEbFgzbC83blh4ejBEUUJramZI?=
 =?utf-8?B?TFFZRGxTbGFLRG8xejlNMGc1OTIrVGhteEY2M05RSjliTWMvaERPT2UwWkZk?=
 =?utf-8?B?VU9oYVVxbkp4WER0VXlCZkFZTDBJa2J6TWRHODlzdnlSdFFqM3BWb1kwSGUv?=
 =?utf-8?Q?8O89cF4VIfOiVUw7cQpcF9c=3D?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4919604-d7df-4cb4-ecdb-08de2d3d2ac4
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 22:43:06.6970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5CcQVQKlNQYMIKEZu55om5kC2pVUPyFvWdwQC4NrkVz0bxVyMMUAUvjlUGmlWNcRlCLuoj+BAe9+g8IaPnp8Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3989
X-Authority-Analysis: v=2.4 cv=CcYFJbrl c=1 sm=1 tr=0 ts=6927827e cx=c_pps
 a=U89Fr+s++Oy0xugnv2TZpA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8
 a=4aMSnsgnDaapfm63974A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: RdKsjesLLWMFEBJcfPwD1IIPvM05LmmM
X-Proofpoint-ORIG-GUID: kSNpjNyHHb0viQvY86LV6XGzO7y7kcZz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAxNiBTYWx0ZWRfX2Bwua39Y4YQd
 VXAw59blHByx37l7eX0bGCXcI2xfGhaK01mu6jPcMO3fv/BV4QgfZRW1m/x5CyqQ3tTZ4pmDOsW
 G3NrgRR7UxOquCkQTwp95OXj6yBfIJtGn+oFCau/k7QW7CtPlVKM5MmAOQCXptH5MSE+5r6FEJZ
 R2QbU6lrL5pW1X7UosLtOMaBo8nQwP0Rs5XB+9bz0EkJgxAurzt+v+MRPm5jgffVlx3dn/inxTe
 N25Gmp8R5dRW2NKV8mXFiGDjAtqM44Gb18W7vMqjPIDR9qZIzBNtF0wvAnK3nxoA9bGicb8aryR
 FsITrsZdT1m0mx43ACIqcDqR6Yizdvy9gcjh8SImSFCLgNGv2MUHm3VReW4KT06YYQLPMTrQh19
 hLlI+FYAw9OUlR5morI/l8oTiL/9AA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <123C508B8363B64493942ABFADA94EA6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: RE: Status of running xfstests for NILFS2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 clxscore=1015 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=2 engine=8.19.0-2510240000
 definitions=main-2511220016

On Wed, 2025-11-26 at 22:00 +0900, Ryusuke Konishi wrote:
> On Tue, Nov 25, 2025 at 4:53=E2=80=AFAM Viacheslav Dubeyko  wrote:
> >=20
> > On Fri, 2025-11-21 at 23:17 +0900, Ryusuke Konishi wrote:
> > > On Wed, Nov 19, 2025 at 8:23=E2=80=AFAM Viacheslav Dubeyko wrote:
> > > >=20
> > > > Hi Ryusuke,
> > > >=20
> > > > On Sun, 2025-11-16 at 00:44 +0900, Ryusuke Konishi wrote:
> > > > > Hi Viacheslav,
> > > > >=20
> > > > > On Fri, Nov 14, 2025 at 9:19=E2=80=AFAM Viacheslav Dubeyko wrote:
> > > > > >=20
> > > > > > Hi Ryusuke,
> > > > > >=20
> > > > > > I did run the xfstests suite for NILFS2. As far as I can see, t=
here are 156
> > > > > > failed tests and I needed to exclude 2 tests from running.
> > > > > >=20
> > > > > > sudo ./check -g auto -E ./my_exclude.txt
> > > > > > FSTYP         -- nilfs2
> > > > > > PLATFORM      -- Linux/x86_64 hfsplus-testing-0001 6.18.0-rc3+ =
#93 SMP
> > > > > > PREEMPT_DYNAMIC Wed Nov 12 14:37:49 PST 2025
> > > > > > MKFS_OPTIONS  -- /dev/loop51
> > > > > > MOUNT_OPTIONS -- /dev/loop51 /mnt/scratch
> > > > > >=20
> > > > > > <skipped>
> > > > > >=20
> > > > > > Failures: generic/003 generic/040 generic/041 generic/068 gener=
ic/074
> > > > > > generic/075 generic/078 generic/080 generic/086 generic/092 gen=
eric/097
> > > > > > generic/099 generic/100 generic/103 generic/105 generic/109 gen=
eric/112
> > > > > > generic/117 generic/121 generic/122 generic/124 generic/127 gen=
eric/129
> > > > > > generic/131 generic/136 generic/177 generic/182 generic/192 gen=
eric/215
> > > > > > generic/221 generic/237 generic/241 generic/245 generic/246 gen=
eric/247
> > > > > > generic/248 generic/249 generic/251 generic/255 generic/257 gen=
eric/258
> > > > > > generic/260 generic/285 generic/286 generic/307 generic/309 gen=
eric/310
> > > > > > generic/313 generic/316 generic/318 generic/319 generic/322 gen=
eric/337
> > > > > > generic/348 generic/360 generic/363 generic/365 generic/375 gen=
eric/376
> > > > > > generic/377 generic/394 generic/403 generic/404 generic/408 gen=
eric/409
> > > > > > generic/410 generic/411 generic/420 generic/425 generic/428 gen=
eric/430
> > > > > > generic/431 generic/432 generic/433 generic/436 generic/437 gen=
eric/438
> > > > > > generic/439 generic/443 generic/444 generic/445 generic/448 gen=
eric/469
> > > > > > generic/471 generic/478 generic/483 generic/484 generic/485 gen=
eric/486
> > > > > > generic/489 generic/490 generic/503 generic/504 generic/510 gen=
eric/512
> > > > > > generic/516 generic/519 generic/523 generic/529 generic/533 gen=
eric/535
> > > > > > generic/537 generic/539 generic/547 generic/553 generic/555 gen=
eric/563
> > > > > > generic/565 generic/567 generic/568 generic/571 generic/585 gen=
eric/589
> > > > > > generic/590 generic/607 generic/610 generic/611 generic/614 gen=
eric/616
> > > > > > generic/618 generic/629 generic/631 generic/632 generic/634 gen=
eric/637
> > > > > > generic/638 generic/639 generic/640 generic/650 generic/676 gen=
eric/690
> > > > > > generic/695 generic/697 generic/704 generic/706 generic/712 gen=
eric/713
> > > > > > generic/715 generic/718 generic/719 generic/723 generic/724 gen=
eric/725
> > > > > > generic/728 generic/732 generic/736 generic/738 generic/741 gen=
eric/742
> > > > > > generic/749 generic/754 generic/758 generic/759 generic/763 gen=
eric/764
> > > > > > generic/771
> > > > > > Failed 156 of 767 tests
> > > > > >=20
> > > > > > I needed to exclude generic/740 and generic/753. I am not compl=
etely sure what
> > > > > > is wrong with generic/740 (it could be glitch on my side). But =
generic/753 fills
> > > > > > the system log with bunch of errors:
> > > > > >=20
> > > > > > 2025-11-12T18:36:24.171533-08:00 hfsplus-testing-0001 root: run=
 xfstest
> > > > > > generic/753
> > > > > > 2025-11-12T18:36:24.175432-08:00 hfsplus-testing-0001 kernel: r=
un fstests
> > > > > > generic/753 at 2025-11-12 18:36:24
> > > > > > 2025-11-12T18:36:24.243745-08:00 hfsplus-testing-0001 systemd[1=
]: Started
> > > > > > fstests-generic-753.scope - /usr/bin/bash -c "test -w
> > > > > >  /proc/self/oom_score_adj && echo 250 > /proc/self/oom_score_ad=
j; exec
> > > > > > ./tests/generic/753".
> > > > > > 2025-11-12T18:36:26.068288-08:00 hfsplus-testing-0001 kernel: N=
ILFS (dm-0):
> > > > > > segctord starting. Construction interval =3D 5 second
> > > > > > s, CP frequency < 30 seconds
> > > > > > 2025-11-12T18:36:26.082067-08:00 hfsplus-testing-0001 nilfs_cle=
anerd[763354]:
> > > > > > start
> > > > > > 2025-11-12T18:36:26.082949-08:00 hfsplus-testing-0001 nilfs_cle=
anerd[763354]:
> > > > > > pause (clean check)
> > > > > > 2025-11-12T18:36:28.111323-08:00 hfsplus-testing-0001 kernel: B=
uffer I/O error
> > > > > > on dev dm-0, logical block 2621424, async page r
> > > > > > ead
> > > > > ...
> > > > > > 2025-11-12T18:36:28.398430-08:00 hfsplus-testing-0001 kernel: N=
ILFS (dm-0): I/O
> > > > > > error writing log (start-blocknr=3D49152, block-c
> > > > > > ount=3D418) in segment 24
> > > > > >=20
> > > > > > I need to double check but likewise error happens not only for =
generic/753 test-
> > > > > > case. As far as I can see, other test-cases also triggered such=
 issue. But
> > > > > > namely generic/753 hangs infinitely with such error messages.
> > > > >=20
> > > > > Okay, I'll take a look at xfstests/753 and related tests.
> > > > > To be honest, I've been busy lately and haven't had much time, bu=
t I
> > > > > hope to have some time after Tuesday.
> > > > >=20
> > > >=20
> > > > It's OK. We are not in a hurry. And it's a lot of tests are failing=
 right now.
> > > >=20
> > > > > > I believe it makes sense to account all of these issues in some=
 tracking system
> > > > > > before starting to fix it. Are you using any tracking system fo=
r NILFS2 issues?
> > > > > > Frankly speaking, I am using github's tracking system for HFS/H=
FS+ issues [1].
> > > > > > It's simple enough but I don't need in more complex system for =
this right now.
> > > > > > So, what do you think about some bug tracking system for NILFS2?
> > > > >=20
> > > > > We don't have a central BTS that we operate. We did have one duri=
ng
> > > > > development, but it wasn't open and is no longer usable.
> > > > > So we either use a mailing list or syzbot, and although I don't
> > > > > particularly want or use it, nilfs-utils' github plays a role in =
that
> > > > > regard.
> > > > >=20
> > > > > As for managing issues raised by xfstests, as you say, I agree th=
at a
> > > > > proper BTS is needed.
> > > > > However, something that is heavily web-dependent like github does=
n't
> > > > > work well with mailing lists, so I'm honestly not sure if it's a =
good
> > > > > solution for this project, apart from github-based development
> > > > > projects.
> > > > >=20
> > > > > In this regard, I think syzbot is good, because email exchanges
> > > > > naturally become a response history and are easily shared with the
> > > > > mailing list.
> > > > > Unfortunately, it doesn't cover the entire issue tracking.
> > > > >=20
> > > > > If you're going to use github for issue tracking, it would be bet=
ter
> > > > > if it could be set up to be highly compatible with mailing lists.
> > > > > What do you think?
> > > > >=20
> > > >=20
> > > > I like your suggestion. But what particular BTS candidate do you ha=
ve in mind?
> > >=20
> > > Github comes to mind here.
> > > When you use GitHub for HFS/HFS+, do you apply any special approach to
> > > tie it into the mailing-list workflow?
> > > Or do you treat it as a completely separate tool?
> > >=20
> >=20
> > Frankly speaking, I simply needed something as fast as possible at that=
 time. :)
> > I created github repository for managing HFS/HFS+ patches before I had
> > repository on kernel.org. And I realized that github has pretty simple =
tracking
> > system that integrated into repository. I didn't think about integratio=
n of it
> > into mailing-list workflow. Anybody can add link on issue into patch an=
d leave
> > any number of comments in the issue's ticket. I considered that it's go=
od
> > enough. I assume that in your terminology I am using it as separate too=
l.
> >=20
> > Also, github's tracking system provides the opportunity to assign the i=
ssue on
> > people. And it is possible classify issues on project/feature basis. So=
, it's
> > simple but reasonable not bad, from my point of view.
> >=20
> > But how do you imagine integration into mailing-list workflow? Could bu=
gzilla
> > provide the necessary features?
>=20
> Bugzilla is a system that easily integrates with mailing list
> workflows, which is probably why it has been in use at kernel.org for
> so long. However, to be honest, I don't think it's suitable for a
> project starting BTS now.
>=20
> The requirements I envision are similar to those of syzbot. It's not
> difficult. Specifically,
>=20
> - Interactions with the mailing list should be linked to issues,
> allowing for bidirectional referencing.
> - Optionally, the ability to indirectly control issue tracking by
> sending a specific CC: email to a specific BTS-linked email address
> using a specific format (such as syzbot's #syz dup: or #syz fix:
> control method).
> - More optionally, the ability to use OSS activity support features
> (such as syzbot's #syz test: command, which allows us to delegate
> reproduction testing).
> In today's world, it would be something like the ability to kick off
> an AI engine and request a first-stage analysis of the issue using
> concise natural language.
>=20
> I think it would probably be a good idea to register issues on GitHub
> anyway, use a self-hosted n8n as the glue for example, and link GitHub
> and gmail (for ML integration) with an AI engine like Gemini and
> ChatGPT.
> However, posting AI output to a public mailing list raises social
> responsibility issues, which is an obstacle to a public email-based
> workflow.
> (We'll probably need a moderation mechanism in place to ensure only
> developer-approved content is sent to ML.)
>=20
> > > > > Personally, I'd like to see a better issue tracking system that c=
an
> > > > > bridge with email-driven workflows, flexibly connect with AI, and
> > > > > support OSS activity, but I don't know of anything other than Git=
Hub
> > > > > that I think would be suitable.
> > > > >=20
> > > >=20
> > > > So, this is my worry that we could not find good and free BTS. And,=
 finally, we
> > > > will need to use anything not very good but accessible right now. :)
> > >=20
> > > Yes, that=E2=80=99s probably how it will end up.
> > >=20
> >=20
> > AI becomes more powerful with every day. So, I don's see any problem fo=
r AI to
> > digest even github's issue system. :)
> >=20
> > > > > > As far as I can see, syzbot still reports about 5 issues for NI=
LFS2 [2]. So, it
> > > > > > makes sense to account these issues too.
> > > > >=20
> > > > > I think it's fine to use it solely for issue management purposes,=
 as
> > > > > long as it doesn't result in double management.
> > > > > Therefore, I think we should make sure to always jump to syzbot f=
rom
> > > > > GitHub, etc., as an index, and make good use of syzbot's workflow=
 as
> > > > > is.
> > > > >=20
> > > >=20
> > > > I am simply thinking to have some tracking system that can account =
all NILFS2
> > > > issues. The syzbot has its own tracking system. But, from my point =
of view, it
> > > > makes sense to account syzbot issues like sub-class of issues.
> > >=20
> > > I don=E2=80=99t think there=E2=80=99s any difference in our thinking.
> > >=20
> > > You mean using GitHub or some other tool to manage the overall set of
> > > issues, right?
> > > Issues from syzbot would be handled primarily within syzbot, but we
> > > would use GitHub or similar as an index alongside other issues.
> > > That approach sounds good to me.
> > >=20
> > > I'm still looking for good BTS, but it might be quicker to start
> > > making them on github now.
> > >=20
> > >=20
> >=20
> > This was my point. :)
> >=20
> > Probably, you need to enable the issue system for NILFS2 on github some=
how.
> > Because, currently, I don't see anything available. And I don't remembe=
r already
> > how I did it.
>=20
> Okay.
> I'm thinking of creating a nilfs2 (linux) clone repository at
> https://github.com/nilfs-dev/   so that we can file issues there.
> Is that okay?
>=20
>=20

Yes, makes sense. Looks like a good place for collaboration.

Thanks,
Slava.
