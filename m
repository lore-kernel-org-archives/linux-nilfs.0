From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Subject: Re: [PATCH 06/10] hugetlbfs: Convert
 remove_inode_hugepages() to use filemap_get_folios()
Date: Fri, 10 Jun 2022 20:35:30 +0200
Message-ID: <20220610203530.7f84bbc0@thinkpad>
References: <20220605193854.2371230-7-willy@infradead.org>
 <20220610155205.3111213-1-sumanthk@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:Content-Type:MIME-Version
 :References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=Ff3S4Dmkc/EDKyt1tbsvQyIpd2d1S9VM2W5+qZ2nG3s=; b=NaSmkCrLoLwnGflUJAIrqTC2JU
 3SWV0FLckcBSxJWDlhtP9fbHkkGtLZp+XJncp9XGuUwPPEMrlpoz+CnohSJTCe5Ix7OzgHBaH906O
 ohALk9nJNW7n8wBbFhsqZmfB1XI4nxyAwa3V77WrL/Hh/sKcT6XAJ6iShhC+lNyaFmYo=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
 In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=Ff3S4Dmkc/EDKyt1tbsvQyIpd2d1S9VM2W5+qZ2nG3s=; b=Lt7Zf0x0F5VCzkTn6VIHNUtqMD
 8jvICKPkfq2SzCUy2Yd8IMcZv6RtnmpIKAKZZxVufCqch7DcwAnUWOqXK6JWjRcGRlXwc+5M2nE+0
 DXoK0+dFxsWSkuwjW4dGLYdb0+PCv7oIoExswqtpEZawOyKtlKjFXGEDebRKwjziPQ5s=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ff3S4Dmkc/EDKyt1tbsvQyIpd2d1S9VM2W5+qZ2nG3s=;
 b=SCN1AstLfBC3fODuKUXKBY6WrlZrz3fThbU1wCedwFT0CaFQD5jJxGOYZdT/ajeMEL/u
 uANcjk+7qt9eYyJ18VOhHCJV6Df7HaLGzno0nD2f85JtoJBClfxRMcZ+0TT0qn3p8KRZ
 7b/8XKkUc83HWO4UeeTgz9FJ7DcRoIi8yuTEHGrN9AKAbC/jeAwZ2+DaIshwH8XCfvpN
 eOr3ay+BYBuGwNhUvP8p+dn7HgW2witLegMJ1wVQCilvjGKmx1pL3G5i73v9Tb/cXZAK
 yZKr3reZ12SDFAq1E2OfXbjlgGKDTOmPfnQChktV0nDHmoJ5aBjo3otDWzZNFzIGAHpN Fw== 
In-Reply-To: <20220610155205.3111213-1-sumanthk@linux.ibm.com>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: willy@infradead.org
Cc: linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org, gor@linux.ibm.com, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Sumanth Korikkar <sumanthk@linux.ibm.com>, linux-ext4@vger.kernel.org, agordeev@linux.ibm.com

On Fri, 10 Jun 2022 17:52:05 +0200
Sumanth Korikkar <sumanthk@linux.ibm.com> wrote:

[...]
> 
> * Bisected the crash to this commit.
> 
> To reproduce:
> * clone libhugetlbfs:
> * Execute, PATH=$PATH:"obj64/" LD_LIBRARY_PATH=../obj64/ alloc-instantiate-race shared
>  
> Crashes on both s390 and x86. 

FWIW, not really able to understand the code changes, so I added some
printks to track the state of inode->i_data.nrpages during
remove_inode_hugepages().

Before this commit, we enter with nrpages = 99, and leave with nrpages = 0.
With this commit we enter with nrpages = 99, and leave with nrpages = 84
(i.e. 99 - PAGEVEC_SIZE), resulting in the BUG later in fs/inode.c:612.

The difference seems to be that with this commit, the outer
while(filemap_get_folios) loop is only traversed once, while before
the corresponding while(pagevec_lookup_range) loop was repeated until
nrpages reached 0 (in steps of 15 == PAGEVEC_SIZE for the inner loop).

Both before and after the commit, the pagevec_count / folio_batch_count
for the inner loop starts with 15, but before the pagevec_lookup_range()
also increased &next in steps of 15, while now the filemap_get_folios()
moved &next from 0 to 270 in one step, while still only returning
15 as folio_batch_count for the inner loop. I assume the next index
of 270 is then too big to find any other folios, so it stops after the
first iteration, even though only 15 pages have been processed yet with
remove_huge_page(&folio->page).

I guess it is either wrong to return 15 as folio_batch_count (although
it seems that would be the maximum possible value), or it is wrong to
advance &next by 270 instead of 15.

Hope that makes any sense, and might be of help for debugging, to someone
more familiar with this code.
