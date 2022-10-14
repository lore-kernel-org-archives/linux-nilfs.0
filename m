From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 05/23] afs: Convert
 afs_writepages_region() to use filemap_get_folios_tag()
Date: Fri, 14 Oct 2022 14:59:34 +0100
Message-ID: <1569540.1665755974@warthog.procyon.org.uk>
References: <20220901220138.182896-6-vishal.moola@gmail.com>
 <20220901220138.182896-1-vishal.moola@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665755984;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=k8qQltuyjmygy+O43yanVxeFaxBvrjiQoX3IXlPZtGE=;
	b=Mh6rKiUNWxpiBi5AY9mN+s2je8QY4V/mzuD++2S1jb/qbdqtzHhebjciovYAmh8jtMT8qz
	15/1PREQUedj6UbTrv07bZQlh0Ianrfb9T9FJnz7/IsNZ1+nFiA0lEci1sDICJDmn9uo7W
	2X8es5W1NzhX8pLL1QEjmHEA3dB2N9k=
In-Reply-To: <20220901220138.182896-6-vishal.moola@gmail.com>
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
Content-ID: <1569539.1665755974.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 7bit
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-cifs@vger.kernel.org, cluster-devel@redhat.com, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, dhowells@redhat.com, linux-mm@kvack.org, linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

Vishal Moola (Oracle) <vishal.moola@gmail.com> wrote:

> Convert to use folios throughout. This function is in preparation to
> remove find_get_pages_range_tag().
> 
> Also modified this function to write the whole batch one at a time,
> rather than calling for a new set every single write.
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

Tested-by: David Howells <dhowells@redhat.com>

