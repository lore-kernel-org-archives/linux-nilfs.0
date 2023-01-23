From: Christoph Hellwig <hch@lst.de>
Subject: Re: return an ERR_PTR from __filemap_get_folio v2
Date: Mon, 23 Jan 2023 20:18:13 +0100
Message-ID: <20230123191813.GA16510@lst.de>
References: <20230121065755.1140136-1-hch@lst.de>
 <20230121170641.121f4224a0e8304765bb4738@linux-foundation.org>
 <20230122072006.GA3654@lst.de>
 <20230123105945.958075d46b0a05ffd545e276@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674501505;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=LB+L+utv/cDjzWqbemZ5ANVNCUgUpSnHnn1bZRYaO6g=;
	b=Kd3m376PF0fEv4nhWEHsPAbdReSM6bDOfXZ0++gD4r6HkZm8X43KVO6EKqNgGhsjME7Zla
	Ko4haS2uEFNTPoT4e1eznhT/xFVlp1Y+n1HaGmhPY3AlwPzpkbuUpaoJWvDeJlPXGv3Ues
	BgLtd/2t+9ADXBK2LuhhskRYVgpO8us=
In-Reply-To: <20230123105945.958075d46b0a05ffd545e276@linux-foundation.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/cluster-devel>, 
 <mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/cluster-devel/>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/cluster-devel>,
 <mailto:cluster-devel-request@redhat.com?subject=subscribe>
Errors-To: cluster-devel-bounces@redhat.com
Sender: "Cluster-devel" <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>, linux-afs@lists.infradead.org, cluster-devel@redhat.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org

On Mon, Jan 23, 2023 at 10:59:45AM -0800, Andrew Morton wrote:
> On Sun, 22 Jan 2023 08:20:06 +0100 Christoph Hellwig <hch@lst.de> wrote:
> 
> > On Sat, Jan 21, 2023 at 05:06:41PM -0800, Andrew Morton wrote:
> > > This patchset doesn't apply to fs/btrfs/ because linux-next contains
> > > this 6+ month-old commit:
> > 
> > Hmm.  It was literally written against linux-next as of last morning,
> > which does not have that commit.
> 
> Confused.  According to 
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/fs/btrfs/disk-io.c#n4023
> 
> it's there today.  wait_dev_supers() has been foliofied.

Yes, it's there now.  But I'm pretty sure it wasn't there when
I did the last rebase.  Weird.

