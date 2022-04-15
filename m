From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH 02/27] target: pass a block_device to
 target_configure_unmap_from_queue
Date: Fri, 15 Apr 2022 05:38:03 +0000
Message-ID: <c440aaea-6617-c26d-e2a1-2107bcc4559e@nvidia.com>
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-3-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+74sie7PTwpCtd24VFJpkgQyUHaJLy3D4yyRUD7Tn80=;
 b=aX918WIKGvRh0tesQxl97U66xWhTmwqBIixj+qqe6353AASra41tNuWIdyvJ0vv9dQuICMgse/4m+4sEFOAgwqDdqDLbtuTg+2eqdw9cqypNegR5AKwfzSGQ1esrzo/wqwj0T/SF/5Xq3ZUMfv86VEhgFcm/d8HjvpV90yTcuZmGT9BoDQ2ZNEdaC6P5vnZpS5LndgKkG0xoHdwdJVgX4J23Vtg2C2BgtRzrm98UHRiTB9oXIc1fL1jKIbOl3x2UWtOsza1IaNuPOy5hW3xwiDsoHLYUJpQZUZi7kcn4K/DoR+forZO4IfXT1zGUDGyKDUdHsugwnYbNEZsknTQS8g==
In-Reply-To: <20220415045258.199825-3-hch@lst.de>
Content-Language: en-US
Content-ID: <98CD87A15D6DAE479794C1E9643FCF3A@namprd12.prod.outlook.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "nbd@other.debian.org" <nbd@other.debian.org>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>

T24gNC8xNC8yMiAyMTo1MiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFRoZSBTQ1NJIHRh
cmdldCBkcml2ZXJzIGlzIGEgY29uc3VtZXIgb2YgdGhlIGJsb2NrIGxheWVyIGFuZCBzaG91bA0K
PiBkIGdlbmVyYWxseSB3b3JrIG9uIHN0cnVjdCBibG9ja19kZXZpY2UuDQo+ICA+IFNpZ25lZC1v
ZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiBSZXZpZXdlZC1ieTogTWFy
dGluIEsuIFBldGVyc2VuIDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT4NCg0KRXhjZXB0IGZy
b20gc3BsaXQgd29yZCBpbiBsb2cgInNob3VsZCIsIGxvb2tzIGdvb2QuDQoNClJldmlld2VkLWJ5
OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0K
