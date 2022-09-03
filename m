From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: [PATCH 21/23] nilfs2: Convert
 nilfs_copy_dirty_pages() to use filemap_get_folios_tag()
Date: Sun, 4 Sep 2022 02:37:53 +0900
Message-ID: <CAKFNMok9qtqHkHzCGW2jckej3ZO47dvU2x+EQ1mJNwVHFHuzvw@mail.gmail.com>
References: <20220901220138.182896-1-vishal.moola@gmail.com>
 <20220901220138.182896-22-vishal.moola@gmail.com>
Mime-Version: 1.0
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662226700;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=Z1VGvcyPcxaVL7OhRrzeu9KO4THMsdUZs/+YFm2RijY=;
	b=gMwIuecBUqpxtccTzDhu9SlV1pB0SKhiP497ZflKi01SmIuEASD1jfg5ReLg/8RzzAoTsV
	fmmUVwA6Xt/bD9EK0DYw+kBTb7msC0MuIRBVI196UkXznHgfG3W52qCBLpKMcnTtSuJGHY
	QO82ey0M7iCnvyacD2bY+MbEnKQb2R4=
In-Reply-To: <20220901220138.182896-22-vishal.moola@gmail.com>
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

On Fri, Sep 2, 2022 at 7:18 AM Vishal Moola (Oracle) wrote:
>
> Convert function to use folios throughout. This is in preparation for
> the removal of find_get_pages_range_tag().
>
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---
>  fs/nilfs2/page.c | 39 ++++++++++++++++++++-------------------
>  1 file changed, 20 insertions(+), 19 deletions(-)

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Thanks,
Ryusuke Konishi

