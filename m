From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH 10/27] mm: use bdev_is_zoned in claim_swapfile
Date: Fri, 15 Apr 2022 05:40:52 +0000
Message-ID: <0da96aad-412b-9afa-c42d-92ca2a650d1e@nvidia.com>
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-11-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9xPbQGHhQ4OpqliAE2ppXjst3khmyYefsmdMvrf0gYE=;
 b=jm6qn2n01mei+/os+xEVde2HSiJOmUg3q2UrHEN9LjaywMdGQwJFt77WfC70RrylqIfeYNwzM3TMGodHOlZkAvg4lYloMyZ1DpLg869ufX2Y5nXmupQYG4w9ZvAK9mZlkd1+0lndelrlNYigERJuS01UMGYPMxdei2NImPnA7vKA1bz6Sm5r4C+crImloG6Ba2xeBfe8WqxpMFN8iAOZs9zr8x9oAuNvOOt/yRwOPLHtLe+IsLkTaS+LwmdWGwtfuGnOTPuhKv/4Kfu5EC0YHUxh5DDCLvJ/TUPmku9oaurCrlU+EyFlVLn4TA8SDJSgK9IyIMWA3cOO9m08nHQbXQ==
In-Reply-To: <20220415045258.199825-11-hch@lst.de>
Content-Language: en-US
Content-ID: <807FABDDF8F92345AAFE5DF5D2053FEC@namprd12.prod.outlook.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "nbd@other.debian.org" <nbd@other.debian.org>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>

T24gNC8xNC8yMiAyMTo1MiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFVzZSB0aGUgYmRl
diBiYXNlZCBoZWxwZXIgaW5zdGVhZCBvZiBwb2tpbmcgaW50byB0aGUgcXVldWUuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gLS0tDQoNCkxv
b2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEu
Y29tPg0KDQotY2sNCg0KDQo=
