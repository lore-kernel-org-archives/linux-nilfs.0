From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH v11 10/63] xarray: Add xa_for_each
Date: Sun, 22 Apr 2018 15:33:23 -0500
Message-ID: <3c759f62-a1fa-9bdd-9b02-7c4e1d2b3adb@suse.de>
References: <20180414141316.7167-1-willy@infradead.org>
 <20180414141316.7167-11-willy@infradead.org>
 <35a3318d-69d7-a10c-1515-98ea6b59fb99@suse.de>
 <20180421013406.GM10788@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
 MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=sfkeWbzmft0POZgSRT0RerFaOhUXQPXtXMfUsT0Ub7g=; b=AnjSzgmNKPeahC3ZgtmeZy9Gr+
 vfqnRBBPf9MA22Uo+ZxawoySDMVKhc2k4Tzsgq7J9heN1dzhLh1lsI/GIxSOnn26rVDKawqSEIPOO
 LVAM5D7cv4sz1Tx0pv/NV8csu0vqt6Jad3ZzZUIw5eLEDVdzt14OyIU2UXieSN1s0x0I=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
 Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=sfkeWbzmft0POZgSRT0RerFaOhUXQPXtXMfUsT0Ub7g=; b=Ikb9qf20Ez28QNdMjW1Orx0CUh
 ptrov74OSAjzLtcjXdwWFa/GT73H/z3vQKvxHiUBiLDmx/nKG/SaARN3sU5eEJFeZ8VfzDjw1ru8B
 R99mlUSpxm2X3NSLDHzt9emExtQjXdLwu5Q5uXULsON83swKUdbRrWnBSp34DrW2nVNo=;
In-Reply-To: <20180421013406.GM10788@bombadil.infradead.org>
Content-Language: en-US
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, James Simmons <jsimmons@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Andreas Dilger <andreas.dilger@intel.com>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Oleg Drokin <oleg.drokin@intel.com>, linux-mm@kvack.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Mike Kravetz <mike.kravetz@oracle.com>



On 04/20/2018 08:34 PM, Matthew Wilcox wrote:
> On Fri, Apr 20, 2018 at 07:00:47AM -0500, Goldwyn Rodrigues wrote:

>> This function name sounds like you are performing the operation for each
>> tag.
>>
>> Can it be called xas_for_each_tagged() or xas_tag_for_each() instead?
> 
> I hadn't thought of that interpretation.  Yes, that makes sense.
> Should we also rename xas_find_tag -> xas_find_tagged and xas_next_tag
> -> xas_next_tagged?

Yup. The family of functions that work with one tag should be renamed. I
am fine with the names suggested.


-- 
Goldwyn

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
