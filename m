From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH 03/27] target: fix discard alignment on partitions
Date: Fri, 15 Apr 2022 05:39:32 +0000
Message-ID: <883810d2-c170-388d-a031-63a9792fef5e@nvidia.com>
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-4-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=omIGCLGdXguYoUP6MBg7rPuCF4y33QrfLBFAULbl9Lk=;
 b=WKHIMc22M8cT1F4TOOdGS5jyRprS6YflieD57kJ9VHosgbK2qXi00dqf1n91wOkO7ioZIoaivqfw2E8t2/tyTEF80oWdFDeVot1F/XsxETSyu/JHk8xM6A0Y0XwpTrsf4O49SF9PbJj8oBkC81zk8KAT7ExVsBJV0OJ8x/aLpj/ihQJjIbVXwFkEQ6+f5qx9tlug0RP1HacUA9FoicsZ1wpcWsWsyDNLApdRT/u2WzVzb3oootNWEegrnufnMNAdwghM737ozJ+YrgKft4Jq+BeeiXX6JKM08kFx3qx24exPuw2WdHEFDi9aqAQqG2xTjKa2hWVsPiJe2YQ3F4WmSw==
In-Reply-To: <20220415045258.199825-4-hch@lst.de>
Content-Language: en-US
Content-ID: <308F8700311C87409575E1C200FD2EC0@namprd12.prod.outlook.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "nbd@other.debian.org" <nbd@other.debian.org>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>

T24gNC8xNC8yMiAyMTo1MiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFVzZSB0aGUgcHJv
cGVyIGJkZXZfZGlzY2FyZF9hbGlnbm1lbnQgaGVscGVyIHRoYXQgYWNjb3VudHMgZm9yIHBhcnRp
dGlvbg0KPiBvZmZzZXRzLg0KPiANCj4gRml4ZXM6IGM2NmFjOWRiOGQ0YSAoIltTQ1NJXSB0YXJn
ZXQ6IEFkZCBMSU8gdGFyZ2V0IGNvcmUgdjQuMC4wLXJjNiIpDQo+IFNpZ25lZC1vZmYtYnk6IENo
cmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiBSZXZpZXdlZC1ieTogTWFydGluIEsuIFBl
dGVyc2VuIDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT4NCj4gLS0tDQoNCkhlbHBlciBkb2Vz
IGhhbmRsZSB0aGUgY2FzZSBmb3Igb2YgcGFydGl0aW9uLg0KDQpMb29rcyBnb29kLg0KDQpSZXZp
ZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KLWNrDQoNCg==
