From: =?UTF-8?Q?Jan_H=c3=b6ppner?= <hoeppner@linux.ibm.com>
Subject: Re: [PATCH 24/27] block: remove QUEUE_FLAG_DISCARD
Date: Mon, 11 Apr 2022 14:03:50 +0200
Message-ID: <e971095e-1015-c348-3c24-114193ee5ff0@linux.ibm.com>
References: <20220409045043.23593-1-hch@lst.de>
 <20220409045043.23593-25-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-um-bounces+glud-user-mode-linux-devel=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20210309; h=Sender:
	Content-Transfer-Encoding:Content-Type:List-Subscribe:List-Help:List-Post:
	List-Archive:List-Unsubscribe:List-Id:In-Reply-To:From:References:Cc:To:
	Subject:MIME-Version:Date:Message-ID:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=b+lqQYxNoSWK5aXIRvVFUdJ/V7zHoNovJusYiqKzgTc=; b=SALFJBRdQw7pIK
	eo9fdAilH+SKRBeS9VMkbBS0eU1/BMqOnqjJAgNP/bsLNuUTXZYPuJGalFRzqyJ/OUWScap2sfmti
	YXNaQWkzqx7DgmRS9tOUQEnP+HP+T6BF9AQYPjFiztLHc++Cv/4L0jYaOUU0ZRZ6WuEr89ugBRJVR
	yvp/XoB1wGRe+6uc963tC7fSu+Li2UEGbjukGLR6B3S9VuiH0B/GSKrownQipqorCd8xtsxiXWRHB
	X9PTskZ6MIhwLSUIhrXrKqUHFjOzavCd3N898+nYXGbx/RYIMH3Q8SSiaV6lhT2nREembj/APr3If
	jEKGVPDKC6WDL6b41LRw==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gYNUMVwDP13qlMS4+UHaJJ3PaCFPgROQJTYtqXnOX7M=;
 b=RDqgcHKph8Jm2BhrynHRzlAqx8nGWKQVGDEreK7n+J6njlw2fY/eROIb0LG1Go0keNpO
 U7B7ao4FH0/uzQKEPYrHVhNG/pJ2E7Z6UBEEa2SxZlUdVDQJZ6TEFr72vPR9TSXOEBKG
 MqlChSHpWchCsB0wZHoGw70dgQSIwe1Dr/3iyUd7QHcinyuGvNuFdGbEFCrbqw9Rsc9z
 JkcowV5iFVIqo42z4/eOag4ZGEVEYQqZe/457g+H8egdMxH/HXBM9/jRkB0BPaAeZihE
 GFX1OIArRJYPFHkICDQZB90KgaeOXTtU3/g2gqArNZA/NmuhAbDjv3WPLEAFQ6zGE6gp Sw== 
Content-Language: en-US
In-Reply-To: <20220409045043.23593-25-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-um>,
 <mailto:linux-um-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-um/>
List-Post: <mailto:linux-um@lists.infradead.org>
List-Help: <mailto:linux-um-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-um>,
 <mailto:linux-um-request@lists.infradead.org?subject=subscribe>
Sender: "linux-um" <linux-um-bounces@lists.infradead.org>
Errors-To: linux-um-bounces+glud-user-mode-linux-devel=m.gmane-mx.org@lists.infradead.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-um@lists.infradead.org, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, nbd@other.debian.org, ceph-devel@vger.kernel.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev, ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, "Martin K . Petersen" <martin.petersen@oracle.com>, =?UTF-8?Q?Christoph_B=c3=b6hmwalder?= <chris>

T24gMDkvMDQvMjAyMiAwNjo1MCwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gSnVzdCB1c2Ug
YSBub24temVybyBtYXhfZGlzY2FyZF9zZWN0b3JzIGFzIGFuIGluZGljYXRvciBmb3IgZGlzY2Fy
ZAo+IHN1cHBvcnQsIHNpbWlsYXIgdG8gd2hhdCBpcyBkb25lIGZvciB3cml0ZSB6ZXJvZXMuCj4g
Cj4gVGhlIG9ubHkgcGxhY2VzIHdoZXJlIG5lZWRzIHNwZWNpYWwgYXR0ZW50aW9uIGlzIHRoZSBS
QUlENSBkcml2ZXIsCj4gd2hpY2ggbXVzdCBjbGVhciBkaXNjYXJkIHN1cHBvcnQgZm9yIHNlY3Vy
aXR5IHJlYXNvbnMgYnkgZGVmYXVsdCwKPiBldmVuIGlmIHRoZSBkZWZhdWx0IHN0YWNraW5nIHJ1
bGVzIHdvdWxkIGFsbG93IGZvciBpdC4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVs
bHdpZyA8aGNoQGxzdC5kZT4KPiBSZXZpZXdlZC1ieTogTWFydGluIEsuIFBldGVyc2VuIDxtYXJ0
aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT4KPiBBY2tlZC1ieTogQ2hyaXN0b3BoIELDtmhtd2FsZGVy
IDxjaHJpc3RvcGguYm9laG13YWxkZXJAbGluYml0LmNvbT4gW2J0cmZzXQo+IEFja2VkLWJ5OiBD
b2x5IExpIDxjb2x5bGlAc3VzZS5kZT4gW2JjYWNoZV0KPiAtLS0KCkZvciAKCj4gIGRyaXZlcnMv
czM5MC9ibG9jay9kYXNkX2ZiYS5jICAgICAgIHwgIDEgLQoKQWNrZWQtYnk6IEphbiBIw7ZwcG5l
ciA8aG9lcHBuZXJAbGludXguaWJtLmNvbT4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCmxpbnV4LXVtIG1haWxpbmcgbGlzdApsaW51eC11bUBsaXN0cy5p
bmZyYWRlYWQub3JnCmh0dHA6Ly9saXN0cy5pbmZyYWRlYWQub3JnL21haWxtYW4vbGlzdGluZm8v
bGludXgtdW0K
