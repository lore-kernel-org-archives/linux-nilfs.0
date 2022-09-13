From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: [PATCH v2 18/23] nilfs2: Convert
 nilfs_lookup_dirty_data_buffers() to use filemap_get_folios_tag()
Date: Tue, 13 Sep 2022 10:09:08 +0900
Message-ID: <CAKFNMokZ02Ax9J3Ns_Q2PO8oeg+G7kgqQS7kMJMxSiX92_Vwzg@mail.gmail.com>
References: <20220912182224.514561-1-vishal.moola@gmail.com>
 <20220912182224.514561-19-vishal.moola@gmail.com>
Mime-Version: 1.0
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663031374;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=/XsoyqrT3QB1JAOnynnNk+cD1xAIdvUlxSJ4ed6XIdU=;
	b=AVZrYwJ5nb0tjFZV6OPzSfGIVX8lbpDDhykVWvWViShkxIn5dwUYS/seK5uFwdPYOnoLDy
	fUaZMm+HRWGXvbAPv452Gi3nIG6WoBwifRCPQqulb+fVnHQGX1QtCXHpRzXWaTVKEzHU16
	2l8SRGjitn8NXw2ChubFAHrH1nSHxA8=
In-Reply-To: <20220912182224.514561-19-vishal.moola@gmail.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On Tue, Sep 13, 2022 at 3:30 AM Vishal Moola (Oracle) wrote:
>
> Convert function to use folios throughout. This is in preparation for
> the removal of find_get_pages_range_tag().
>
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---
>  fs/nilfs2/segment.c | 29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Looks good.   Thank you for reflecting the previous comment.

Ryusuke Konishi

