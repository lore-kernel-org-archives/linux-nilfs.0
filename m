Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2080D21579F
	for <linux-nilfs@vger.kernel.org>; Thu,  8 May 2025 11:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746704398; cv=none; b=LZQA7VhKmVThemObycW2Xw+IB77K3IhTHm3VdmfZ2ixBApRNucLxKtMU6w2INmeVxovju1ScaQkBnst3hDwxndgfO4KXk5MXuJC+DLHCpsw4oDJacbEdSzFHIbB6+9b3u4I16JEdRAJ6dagEW8tFa7YInJobtBkKNcDwGtKrmhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746704398; c=relaxed/simple;
	bh=CNe87gFhLNwrymYwLSElRcC8katQ5WYY7ivrdeApVVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BqHKsCX1azjNU/W/hF2XAwSwttmMpC3Gqb8USI5YMacBPmmdtpkt/TJAeYniC3ba7oP8c8dXSRZ441Ks7F7LJuu3LJEdd1AriU0QN0YoMMdQg0AgHIYfPSjp1WJ/2nMSzturzzHKjV/ycoIqSBxJTnMM5fCZJA48PseeRcxnuQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y9w/oVXd; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y9w/oVXd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746704396; x=1778240396;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CNe87gFhLNwrymYwLSElRcC8katQ5WYY7ivrdeApVVk=;
  b=Y9w/oVXdcRkZnZWEbJHazNVeypcgAaoGVPicjbXXXKMyFVH1Vyf6cgIj
   uMj8YoNNfMQP3BvVeW3c9tpgXe8Ly2bJJoMtGS50GFrOLqgXfgakMp0Dj
   iPJeXd4Cxo3skVyv+6et7uc8JhEa3w8RNzltz7yTOcuz4shoGX2frwv4y
   JzLLh88i9PMj+3V8KccAWhorw+Pn/nCZ88/jxGA21gtEmPKy5+6ROq9Yd
   qfIquMTrT+AQL1a9WruNbme+x9ZKGVlxYDwMZsKBKMSRDKJHp2tq0AeHS
   DNmHZCAe6foLKJ6IsibeapPLFRaJijnUNvsJCkb0FuHqfiZwFGGdPtZ3y
   w==;
X-CSE-ConnectionGUID: ZmSz9SQXR0+LMVbfUConAQ==
X-CSE-MsgGUID: Cp7Zu9deT42beFCRgKFUqg==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="59142938"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="59142938"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 04:39:55 -0700
X-CSE-ConnectionGUID: It5zwSqeREiDQNvJt0zqvA==
X-CSE-MsgGUID: /sqej5r5SViqOQ3M6BanJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="136199726"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 08 May 2025 04:39:52 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uCzbS-000AvH-06;
	Thu, 08 May 2025 11:39:50 +0000
Date: Thu, 8 May 2025 19:38:56 +0800
From: kernel test robot <lkp@intel.com>
To: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Hugh Dickins <hughd@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Matthew Wilcox <willy@infradead.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-nilfs@vger.kernel.org
Subject: Re: [PATCH 5/7] mm: stop passing a writeback_control structure to
 swap_writeout
Message-ID: <202505081941.kyY28sRZ-lkp@intel.com>
References: <20250508054938.15894-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250508054938.15894-6-hch@lst.de>

Hi Christoph,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20250507]
[cannot apply to akpm-mm/mm-everything konis-nilfs2/upstream linus/master v6.15-rc5 v6.15-rc4 v6.15-rc3 v6.15-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Christoph-Hellwig/mm-stop-passing-a-writeback_control-structure-to-shmem_writeout/20250508-144804
base:   next-20250507
patch link:    https://lore.kernel.org/r/20250508054938.15894-6-hch%40lst.de
patch subject: [PATCH 5/7] mm: stop passing a writeback_control structure to swap_writeout
config: openrisc-allnoconfig (https://download.01.org/0day-ci/archive/20250508/202505081941.kyY28sRZ-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250508/202505081941.kyY28sRZ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505081941.kyY28sRZ-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/vmscan.c: In function 'writeout':
>> mm/vmscan.c:670:44: error: passing argument 2 of 'swap_writeout' from incompatible pointer type [-Wincompatible-pointer-types]
     670 |                 res = swap_writeout(folio, plug);
         |                                            ^~~~
         |                                            |
         |                                            struct swap_iocb **
   In file included from mm/vmscan.c:69:
   mm/swap.h:146:76: note: expected 'struct writeback_control *' but argument is of type 'struct swap_iocb **'
     146 | static inline int swap_writeout(struct folio *f, struct writeback_control *wbc)
         |                                                  ~~~~~~~~~~~~~~~~~~~~~~~~~~^~~
--
   mm/shmem.c: In function 'shmem_writeout':
>> mm/shmem.c:1644:45: error: passing argument 2 of 'swap_writeout' from incompatible pointer type [-Wincompatible-pointer-types]
    1644 |                 return swap_writeout(folio, plug);
         |                                             ^~~~
         |                                             |
         |                                             struct swap_iocb **
   In file included from mm/shmem.c:44:
   mm/swap.h:146:76: note: expected 'struct writeback_control *' but argument is of type 'struct swap_iocb **'
     146 | static inline int swap_writeout(struct folio *f, struct writeback_control *wbc)
         |                                                  ~~~~~~~~~~~~~~~~~~~~~~~~~~^~~


vim +/swap_writeout +670 mm/vmscan.c

   654	
   655	static pageout_t writeout(struct folio *folio, struct address_space *mapping,
   656			struct swap_iocb **plug, struct list_head *folio_list)
   657	{
   658		int res;
   659	
   660		folio_set_reclaim(folio);
   661	
   662		/*
   663		 * The large shmem folio can be split if CONFIG_THP_SWAP is not enabled
   664		 * or we failed to allocate contiguous swap entries, in which case
   665		 * the split out folios get added back to folio_list.
   666		 */
   667		if (shmem_mapping(mapping))
   668			res = shmem_writeout(folio, plug, folio_list);
   669		else
 > 670			res = swap_writeout(folio, plug);
   671	
   672		if (res < 0)
   673			handle_write_error(mapping, folio, res);
   674		if (res == AOP_WRITEPAGE_ACTIVATE) {
   675			folio_clear_reclaim(folio);
   676			return PAGE_ACTIVATE;
   677		}
   678	
   679		/* synchronous write? */
   680		if (!folio_test_writeback(folio))
   681			folio_clear_reclaim(folio);
   682	
   683		trace_mm_vmscan_write_folio(folio);
   684		node_stat_add_folio(folio, NR_VMSCAN_WRITE);
   685		return PAGE_SUCCESS;
   686	}
   687	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
