From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH 23/27] block: add a bdev_max_discard_sectors helper
Date: Fri, 15 Apr 2022 05:47:13 +0000
Message-ID: <3583727e-1260-0907-1b18-cad774750ed0@nvidia.com>
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-24-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KdzVxQLhOIzwO3EIom1scI2CEKlGZZ29ZfmeWI/0Tzs=;
 b=HAcwx2b4PXoa4zPnYgVIEbCtts9d7sVBpXDyaHqzXDR3VcfBub5R72rObkzotyIEJEQZMAdvbp+1UZSk6FYN2tvzBxBnun7v6RbD1qVyNdK2jdYsj3VJCL+Z4Y0SlfFLbZG1wsqKrRMUAdKkvc+U74nFHzLFwRepcSQh2PDvgynZ+6bg6fY8yYRtAC1ZCJlFp/971+W+s0PcBuS+dZzi89lnlBKfbMbxYX8hRxKMl5x3pKpTZPk/jNyslSRVFcIzJ3B9uMiG7HvVKDBjo7xdJ9yx9ax333Aj4goLKBrY97BONbulZtk/giNDMNXel1JnkyeQ6N2IfbvX3nsw9+ngtQ==
In-Reply-To: <20220415045258.199825-24-hch@lst.de>
Content-Language: en-US
Content-ID: <198DA0096D964E4496BC8D9005BDA9B4@namprd12.prod.outlook.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "nbd@other.debian.org" <nbd@other.debian.org>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>

T24gNC8xNC8yMiAyMTo1MiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEFkZCBhIGhlbHBl
ciB0byBxdWVyeSB0aGUgbnVtYmVyIG9mIHNlY3RvcnMgc3VwcG9ydCBwZXIgZWFjaCBkaXNjYXJk
IGJpbw0KPiBiYXNlZCBvbiB0aGUgYmxvY2sgZGV2aWNlIGFuZCB1c2UgdGhpcyBoZWxwZXIgdG8g
c3RvcCB2YXJpb3VzIHBsYWNlcyBmcm9tDQo+IHBva2luZyBpbnRvIHRoZSByZXF1ZXN0X3F1ZXVl
IHRvIHNlZSBpZiBkaXNjYXJkIGlzIHN1cHBvcnRlZCBhbmQgaWYgc28gaG93DQo+IG11Y2guICBU
aGlzIG1pcnJvcnMgd2hhdCBpcyBkb25lIGUuZy4gZm9yIHdyaXRlIHplcm9lcyBhcyB3ZWxsLg0K
PiANCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IFJl
dmlld2VkLWJ5OiBNYXJ0aW4gSy4gUGV0ZXJzZW4gPG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29t
Pg0KPiBBY2tlZC1ieTogQ2hyaXN0b3BoIELDtmhtd2FsZGVyIDxjaHJpc3RvcGguYm9laG13YWxk
ZXJAbGluYml0LmNvbT4gW2RyYmRdDQo+IEFja2VkLWJ5OiBDb2x5IExpIDxjb2x5bGlAc3VzZS5k
ZT4gW2JjYWNoZV0NCj4gQWNrZWQtYnk6IERhdmlkIFN0ZXJiYSA8ZHN0ZXJiYUBzdXNlLmNvbT4g
W2J0cmZzXQ0KPiAtLS0NCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBL
dWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0KDQoNCg==
