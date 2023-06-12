From: David Howells <dhowells@redhat.com>
Subject: Re: [linux-next:master] [splice] 2cb1e08985:
 stress-ng.sendfile.ops_per_sec 11.6% improvement
Date: Mon, 12 Jun 2023 13:25:48 +0100
Message-ID: <105869.1686572748@warthog.procyon.org.uk>
References: <202306121557.2d17019b-oliver.sang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cluster-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686572771;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=S6ZdyZg6hNdeUU+LQE/L/YOLwn1dgQKDi1YGfrHhXZg=;
	b=ZEF6m28a+gSBKlqe0fYtnt0USTo1xQQpNC/OowodIsJqyhpc4DBd8NQkylIY32cxae/dFD
	MyUvl4fD27i+1ZLdiI2iXdguUDvQop2bR9BLTBEJ+IlQvpwOvYNcOjrOddRExN/c44DJ/t
	nVR0qz19yeDK0WrhPZahpNSsLBxNX2M=
In-Reply-To: <202306121557.2d17019b-oliver.sang@intel.com>
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
Content-ID: <105868.1686572748.1@warthog.procyon.org.uk>
To: kernel test robot <oliver.sang@intel.com>
Cc: jfs-discussion@lists.sourceforge.net, David Hildenbrand <david@redhat.com>, feng.tang@intel.com, dhowells@redhat.com, Linux Memory Management List <linux-mm@kvack.org>, linux-mtd@lists.infradead.org, linux-afs@lists.infradead.org, linux-nilfs@vger.kernel.org, lkp@intel.com, Christoph Hellwig <hch@lst.de>, cluster-devel@redhat.com, ying.huang@intel.com, linux-ext4@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, ecryptfs@vger.kernel.org, linux-um@lists.infradead.org, reiserfs-devel@vger.kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, linux-ntfs-dev@lists.sourceforge.net, fengwei.yin@intel.com, ocfs2-devel@oss.oracle.com, oe-lkp@lists.linux.dev, ntfs3@lists.linux.dev, linux-erofs@lists.ozlabs.org, linux-karma-devel@lists.sourceforge.net, linu

kernel test robot <oliver.sang@intel.com> wrote:

> kernel test robot noticed a 11.6% improvement of stress-ng.sendfile.ops_p=
er_sec on:

If it's sending to a socket, this is entirely feasible.  The
splice_to_socket() function now sends multiple pages in one go to the netwo=
rk
protocol's sendmsg() method to process instead of using sendpage to send on=
e
page at a time.

David

