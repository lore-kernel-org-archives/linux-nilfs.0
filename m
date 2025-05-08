Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5293A1F5F6
	for <linux-nilfs@vger.kernel.org>; Thu,  8 May 2025 13:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746709445; cv=none; b=tUVztce7g37hL0JIAVw1nkEGZHOOOBC/VrNdb6vsRhdOrcY+gS7ypevsG/eaM0CjP6DnHAVdF0nNApKOBKLYb4AZ8PPAfQy5u8Sri5s/NP3FSS59WQedua7iT3xPRSvXljKjw8p9DH624miN6ltCn+tGaNyyuyhhK7InB2MIU7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746709445; c=relaxed/simple;
	bh=oso5DI2uutgxN4edjVRLbKbgp08NRr3SzRMFVbdLXQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TGoJ8N8QDGmDqNu99THtcHywV0qrId9X3AqYS60gpFKMqjaLUm6aGCGQqBNznBmGh83ZDaseZYJZJSuIi9GQ7mmtzECXUeH/GpmyJomtJB/pac8qK1YxgSr1nDma5e4kaMIdSS0cDiyNQpj35hSsO1P8MYSxTQwQ7cikZV1+OdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j2NFR8gs; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j2NFR8gs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746709444; x=1778245444;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oso5DI2uutgxN4edjVRLbKbgp08NRr3SzRMFVbdLXQA=;
  b=j2NFR8gs7V+ksfga7vBGXBsPgls8nKr+1fY1FXudLxo1T7IzWqsSHQXZ
   qXFB5aDC1lkDGH3tbyxhiJJef12/4SfryLoDB/Dwz2yVqBj6cegMT4c3H
   S344w0eP1wp7krY9ILiwFZ5i3U52M7KQPSaC0zthgdJq32Y8SjlxN/Qkc
   9keZdJ8fxNSHtCHUlnTYAS9sDlol4TpUmfqxV+7iwr97Hsje4LZDGqsu2
   NECF8RQSBvIVPvsfXIOnCVZbn1YD1UT6E/1VL7tVOE+rn6ZPlDJFlRsjd
   6k49xDcdb0C/APICyWJXZLBkCrZfntQcmUiSEgAM9SID4cHfHyeeaK8el
   Q==;
X-CSE-ConnectionGUID: NE9y0iKdSdOQ9UEa/wLbtQ==
X-CSE-MsgGUID: uU9ycTY1Q8abt2gZwSnbIg==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="48652730"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="48652730"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 06:04:03 -0700
X-CSE-ConnectionGUID: aHVOJzv/TzanarjAuC0YLQ==
X-CSE-MsgGUID: zmtWPL+ZQfaL8dB1ZEdStg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141185353"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 08 May 2025 06:04:00 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uD0ur-000Ayd-1L;
	Thu, 08 May 2025 13:03:57 +0000
Date: Thu, 8 May 2025 21:03:35 +0800
From: kernel test robot <lkp@intel.com>
To: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Hugh Dickins <hughd@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Matthew Wilcox <willy@infradead.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-nilfs@vger.kernel.org
Subject: Re: [PATCH 2/7] mm: stop passing a writeback_control structure to
 shmem_writeout
Message-ID: <202505082050.us12v40j-lkp@intel.com>
References: <20250508054938.15894-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250508054938.15894-3-hch@lst.de>

Hi Christoph,

kernel test robot noticed the following build warnings:

[auto build test WARNING on next-20250507]
[cannot apply to akpm-mm/mm-everything konis-nilfs2/upstream linus/master v6.15-rc5 v6.15-rc4 v6.15-rc3 v6.15-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Christoph-Hellwig/mm-stop-passing-a-writeback_control-structure-to-shmem_writeout/20250508-144804
base:   next-20250507
patch link:    https://lore.kernel.org/r/20250508054938.15894-3-hch%40lst.de
patch subject: [PATCH 2/7] mm: stop passing a writeback_control structure to shmem_writeout
config: arm-allnoconfig (https://download.01.org/0day-ci/archive/20250508/202505082050.us12v40j-lkp@intel.com/config)
compiler: clang version 21.0.0git (https://github.com/llvm/llvm-project f819f46284f2a79790038e1f6649172789734ae8)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250508/202505082050.us12v40j-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505082050.us12v40j-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: mm/shmem.c:1549 Excess function parameter 'wbc' description in 'shmem_writeout'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
