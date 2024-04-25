Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792A441C76
	for <linux-nilfs@vger.kernel.org>; Thu, 25 Apr 2024 06:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714027737; cv=fail; b=A5mY1dyhQA2iP3FC7oAWYUPqdoiGGCpf9x1vjXc5coiVhpFKohJKHNICtLSCetBzL0xWBMu+W6Uy3iRaz5sTrfiplBcunWAKnkyJBgQpNuGMT5xy0oPS5j3TlN8I/ZjBf5e/KHHvr+DWaPlWA1pRVIW/yAU3nRpDU1U5BmgS1to=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714027737; c=relaxed/simple;
	bh=iexp0AR+ZTqZy5uhQlFJJPgLClgijVhu3MUaMkKuzkk=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=cqd7fox5WZESQeufg5/wAYfDB352TzoKLsrFlm+b/5n55/U9ebLwEmCWc2qt3qFyVGpFGA1xQwvliUfQFbqviKNoDXKyAY9vnuJiT7Pj+MKgRiBMEMFPlfBckdTgWgE1x0/DFAimAqySsHY/oKydldRwba9TfOtibfXREmBFe1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cV7IJyav; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cV7IJyav"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714027735; x=1745563735;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=iexp0AR+ZTqZy5uhQlFJJPgLClgijVhu3MUaMkKuzkk=;
  b=cV7IJyavtAyKQ3qIbnYYeB+SgpSRW9G9jq7pOoncULXBS3rB4Q9qzJmT
   wHRG4TByFYZBIUXltypeDutNY0r/OzQNb+LFBtyQVS1iK5vCalPnzA7eZ
   REn6NF+KYc+ZHNA31WurfVV2BPju8EBhd2BKjiO1T1KZ0CUd0tCVtdR7F
   eS0ZPP6kMqgvIVzXbSENDT6VYxTWrXxUIaJIC3I8yN+tdpGEVNXjmcKzc
   axvoD7w/FjHX9TttJFDo7KgDLTnbi5Kdtg8sBBXl4XfL5P3KhwH1jOhPd
   eVAWHPpZ0t1OnEH5QUKxO41ULXSA8//NljUX3DIHcp1E0JTdASY3CMzRH
   w==;
X-CSE-ConnectionGUID: tUlDWjQQTyqeJbAY5evKMg==
X-CSE-MsgGUID: K2X1RQfFQZKEtBda6leTfw==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="13477911"
X-IronPort-AV: E=Sophos;i="6.07,228,1708416000"; 
   d="scan'208";a="13477911"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 23:48:54 -0700
X-CSE-ConnectionGUID: k+UdfOE3RzKzjeHg+EtR6w==
X-CSE-MsgGUID: WQKnix/nS9i+7j9s3jxsbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,228,1708416000"; 
   d="scan'208";a="25587053"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Apr 2024 23:48:54 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 24 Apr 2024 23:48:53 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 24 Apr 2024 23:48:53 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 24 Apr 2024 23:48:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AOUgojITxhE4zbahprQhr7UnHw2ZhQf6UhrNciUxL/ybAVTnbcjlpzgE3+OikYhRmGpk9okUgrn7yDeYDQVppBZsedztEzlPT2p73Fhd9HXj3QX+nvEAx5gjcoCP5c/BIYcuo5B7fWO5HuyjT+QcFHoW9Z5dgHJXacj0nQ9SFDL0Jy3Ar+0PFrMPsm+0/MkWVb4DrpJ28kLDKzkNCEhBGHGgY2GdE1OE/bg8atmF9Gssi/K+Cq3qhBgAw7aPlgUZbimWkqjo8V/JB9HEGIjRBlFeHfSbSl6RLmn0XFVJB0n0RlLmYLmPTU6hIGXisoe+o0K3aS1uRNguISS9bxi1DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nlz8hVE6l+niWtE3iPC6Li+IZunsro5F5UYMcKiltB8=;
 b=SXi8CYXxMWQE+R10kTHQ6CZi+hgPQCMwSniOwlLngd4H00z6SSnZGZ9Fvi5uK1JePeHFJp1IPUohAbYlY//jiT+xO1I5HCXjKSEv7kjEFPXizp8/a0EBj0eZagUtJLdPf83KgtF2xv0X6SbgX7zZXmmsNdcfbsT6lcacv23JSS6Wv2dKOS39W9xSH2dXMIKIZIlFKH2crJKyevKC4N5Qo0NcpO27TlWjCKlhAiLZEoZK55q/mVcqZ+8KptVp+rrmCmsWQBww+9rbMrMy8Rg9biqBtFN8gcKbcH7MwIvWYhqMRiEztf5wXv9l7xitmdgMiSuCs8gedLqDcfe9U4kU6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8393.namprd11.prod.outlook.com (2603:10b6:806:373::21)
 by MW4PR11MB6935.namprd11.prod.outlook.com (2603:10b6:303:228::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.24; Thu, 25 Apr
 2024 06:48:52 +0000
Received: from SA1PR11MB8393.namprd11.prod.outlook.com
 ([fe80::c0cf:689c:129c:4bcd]) by SA1PR11MB8393.namprd11.prod.outlook.com
 ([fe80::c0cf:689c:129c:4bcd%6]) with mapi id 15.20.7519.021; Thu, 25 Apr 2024
 06:48:52 +0000
Date: Thu, 25 Apr 2024 14:42:19 +0800
From: kernel test robot <yujie.liu@intel.com>
To: Eric Sandeen <sandeen@redhat.com>
CC: <oe-kbuild-all@lists.linux.dev>, <linux-nilfs@vger.kernel.org>, "Ryusuke
 Konishi" <konishi.ryusuke@gmail.com>
Subject: [konis-nilfs2:for-akpm 4/4] fs/nilfs2/super.c: linux/fs_context.h is
 included more than once.
Message-ID: <202404251450.rttcxC1o-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SI2PR02CA0035.apcprd02.prod.outlook.com
 (2603:1096:4:195::22) To SA1PR11MB8393.namprd11.prod.outlook.com
 (2603:10b6:806:373::21)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8393:EE_|MW4PR11MB6935:EE_
X-MS-Office365-Filtering-Correlation-Id: 46c92117-eb6e-4535-53d6-08dc64f3c4b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?dIZRuUgBFsmF5kD102EuEVdTj5CbKE7gkbrnrFhNhqYRqV6G482SGUHqy32/?=
 =?us-ascii?Q?K8MYvSnKg0sfJAuCouYvowGXDkUxhHfYI+DFJxK6GDbZrWA8vFJn9OLeqcMV?=
 =?us-ascii?Q?qqpVHydcPIXmfHpmjkFzlgHzQHRWbZWv/QTAHEFo8EeDoSnm4WGk9AoFmpZ0?=
 =?us-ascii?Q?VfpzwKp8c87S5VMz7QZNm8HXXm3OPkMT3T8St59KY2mzD11cWR+xWamzXQ+Y?=
 =?us-ascii?Q?/IIa9EB/zg9EPco8Zmj+hAfAigtWUIH+RjyUi9pQ1vsWg4EKHr3G+gYmMj/R?=
 =?us-ascii?Q?xNpcR+Hd7adKH0u2PUQlFN2dd+1qobmeuF5JHFlG9gn9jEX46CoXF5XUD7so?=
 =?us-ascii?Q?acDeCnCMNzugWD1FFRud0+Myo7g5SOSpQSO4aUjiM9llDH4RRWILINUSO6FP?=
 =?us-ascii?Q?kIyFZegmLDsYUupFg75u4p8WMJZL16y0FuK7M3aM2ZdzCOi73iItdMESkDei?=
 =?us-ascii?Q?ZcJX/3jcXu0YdVmfv3/weZ73Fd6elUvSjY9Sqp5+pIV5agTLwrm/BuN0vasw?=
 =?us-ascii?Q?PAzfy8sR1PEDRuXSprGscYJAGptfWP88QqqXoLKyNmdvfuGymyHFNUCImRrl?=
 =?us-ascii?Q?t1CtIKEBF5liV13arp+FRodh3zaCPh6OcyULkK/VY0iUQl0VvoDVO+0WWi8E?=
 =?us-ascii?Q?1mWCCg7LBSxh6HT1r/viFvto+GWaQmhIbIDGavRFfdf6Y1MpElbJjBH+QHZK?=
 =?us-ascii?Q?H30gR2eF1I0srh4Fb1KJpbWWy8JM6tIkgpESOeAX2waAJoX1Wze3RMAOU4OU?=
 =?us-ascii?Q?oArVSCdydX7DVOtJn1EeVEieajwcPHsknkYhTlCola4bZrveUQ0KGXm09gvz?=
 =?us-ascii?Q?v2M1RKGJuRn/h5F+2OilbrzYsafFBRfxRcMSEXrwyv6AL2n2dyUKTnwqZmht?=
 =?us-ascii?Q?NiLdWwtHQncNn/Zywy40v/e9Y1L4SFrfczhxlNPueg/WxDSd0diLs+WqLRZh?=
 =?us-ascii?Q?vhuC1rHtMrTZwi7OBIn7eMps7iddWkORFPBNEACAHDM/LaW3UcJC83T0AM/2?=
 =?us-ascii?Q?AAU9+rq/jxIvVXyx0aXhYxuQZbD5/3LepyQvuW6wfsomdlnOxlbKAjy5hbwe?=
 =?us-ascii?Q?qw/+3i1IEZHauSBwyaHUxaaZcn2jDWZhsfvaqINr9BFfTwZhy8oytocVdNDx?=
 =?us-ascii?Q?WjWZS09dCz1EdobKGfq/Bpu/rPZDZ3ikyRn7OklR/lQJDKjAdyr0+b1BPh7H?=
 =?us-ascii?Q?p6zJZQkAmMUhtDHFOvcSAhHuUN6+RpwlcJDXizMxTrja9N7kVYx35g8zIzc?=
 =?us-ascii?Q?=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8393.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z7gpRgdP32f9SRKvu8oUNz6VevinpJr2bZ6HVN+/AYNZG7UEsgNGf6EKDroG?=
 =?us-ascii?Q?YjGynSef57H858kJA4PBcbHqR+ptz4bk61hlJMmqHi5r1k/Dk5cmQqJKNu6N?=
 =?us-ascii?Q?SfA/+HToXmpYsaHJNoZiGsnxOpRWUO5M2D5cPhkG67oWsSwZrcn4PUU7ngGV?=
 =?us-ascii?Q?9d06FE9V+/2KuDhbFIKQQRttfq1gm8kpJMoffG3VS2nF+3fe3MneDzPj6XKm?=
 =?us-ascii?Q?KEtn1p7X0s8iWsX3xV9iqNG75LkO/TkxNG/ZIje2tOi7KphO9GfoiE0j+5LW?=
 =?us-ascii?Q?YyPsGezU8N6K+0BfHo+qHbRGFdH6E0xqzKI7GTbo5I5Bb/Ogltkt0qEs88Ca?=
 =?us-ascii?Q?QaDYxhCpRfLgkBAFWl3u8cqJKw5RmlYEiw9Q0BZw2fDDBcPYJLU7JMKSIMK7?=
 =?us-ascii?Q?NdjC5ztFwZW8EbYwessjg/aKQ6T2FtJBkcJblqoS+/JrKDlUxDbJ2BCB8HYK?=
 =?us-ascii?Q?gTJK/wpZwTBALOeKq6QSWpScH5YPmcBexvPCnsu4NsBvjYJMIUGsqavZIUEd?=
 =?us-ascii?Q?dZPp4O5nsgWnrsmyT5PmHowwxKdEar5bAIM339oWVqOyL2OULvCajBpGOq5V?=
 =?us-ascii?Q?DzT+pJL8WUwX/GVeyjpMN3dxuJtF3jRYns1I4CvG9nuwSenfucp3vzzdY4CC?=
 =?us-ascii?Q?g3MIebWFbR+9qsFBxbw4nchuCpLGSaaYvBqMHMts2jZZWW8vnNGws9U8rck/?=
 =?us-ascii?Q?Yj9JAL9j2D0wR4J70ZJXRB/0P+U/oKMuh+BhHSIjiWtxbfQshT6OoJicukSB?=
 =?us-ascii?Q?+1Qr4eHdfJnBglqDNTDQdVbgLYB5FuJ9aUf4aKain80IIG58w/q2xdBnHShS?=
 =?us-ascii?Q?avqmehJJ7mI0eeMHOYtq8zlEUeu939hYxBoMDBq/kBAfsAxOw6RHHw19bVLX?=
 =?us-ascii?Q?bn/U78uu8DkfRuuTOrSUbtpXfl9UL1qAME2fh31sI54SdzhDyWyrIfXqI0iq?=
 =?us-ascii?Q?NOdiQceTkupQvPL38nIewt7veNV1jzEoonk/OZ6HqmAqIpjPCziaOAqBgU2F?=
 =?us-ascii?Q?1r0quMPZ1yvSGTHapsL8kneE73bGKJeJC8UpdBjJUR8iXsrobJyAfS1+lUlm?=
 =?us-ascii?Q?xounN3HgfKMzHiaQI46VLGSKMDbhpIeKjt4CP5Kcv8eBjHCbtI0bl/05/zv2?=
 =?us-ascii?Q?poEVIz0UrtChUZVcpGTcRy1yWzStgKzgVeUyJVul6FTwdtr0uWD9VOg3/1+y?=
 =?us-ascii?Q?RT25cV1gt/SGb8ITPhIXulPasOee7shK2bB3aNyJMmUIiQDSHZ6LPau6O9jf?=
 =?us-ascii?Q?BDZdOWXFRd8xFdobIuOpTrgQCp/ef694yRVohZu0j6SaAp68IbfTLcHrdHR9?=
 =?us-ascii?Q?WUTC7vrCgsNEqu/aX8LFJCjNwUqQud4dgStBHnCK0zBY2nmuiDf0GZEffSyk?=
 =?us-ascii?Q?I1Kp6gjgIVeqUWbzJ4qClUR5lEpU/AicoY1EAPZjLtTJvfatqm5TxQ1dUcd1?=
 =?us-ascii?Q?DsVgT9kZu9NfrHQlUqG/kpGRXqa7q6B2QRz2WIYYg/90qI1dw+56Z7e9Aarb?=
 =?us-ascii?Q?EmTLSH6dEbX1hcizjHdis9q86iOik500nDKd0VwFJYgVh5YnR4Dyi0I0GTTo?=
 =?us-ascii?Q?pWS1CCA2EgSdCfgE1F07IsbxV4hlinXyDpjU+TVC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 46c92117-eb6e-4535-53d6-08dc64f3c4b7
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8393.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2024 06:48:52.0589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BuXqcDrzrywmSGyJwvviNdKLrzS2BggEjLWdFbXmQSkLgwzjLnG4FfgIuchDh3yOZ34XrZ1CwKGNE/9X19T9Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6935
X-OriginatorOrg: intel.com

tree:   https://github.com/konis/nilfs2 for-akpm
head:   69812977939c7895ede256e122284c19d4d83aef
commit: 69812977939c7895ede256e122284c19d4d83aef [4/4] nilfs2: convert to use the new mount API
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yujie.liu@intel.com>
| Closes: https://lore.kernel.org/r/202404251450.rttcxC1o-lkp@intel.com/

includecheck warnings: (new ones prefixed by >>)
>> fs/nilfs2/super.c: linux/fs_context.h is included more than once.

vim +32 fs/nilfs2/super.c

  > 32	#include <linux/fs_context.h>
    33	#include <linux/fs_parser.h>
    34	#include <linux/crc32.h>
    35	#include <linux/vfs.h>
    36	#include <linux/writeback.h>
    37	#include <linux/seq_file.h>
    38	#include <linux/mount.h>
  > 39	#include <linux/fs_context.h>
    40	#include "nilfs.h"
    41	#include "export.h"
    42	#include "mdt.h"
    43	#include "alloc.h"
    44	#include "btree.h"
    45	#include "btnode.h"
    46	#include "page.h"
    47	#include "cpfile.h"
    48	#include "sufile.h" /* nilfs_sufile_resize(), nilfs_sufile_set_alloc_range() */
    49	#include "ifile.h"
    50	#include "dat.h"
    51	#include "segment.h"
    52	#include "segbuf.h"
    53	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

