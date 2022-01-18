From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH 16/19] block: pass a block_device and opf to
 bio_alloc_kiocb
Date: Tue, 18 Jan 2022 22:12:57 +0000
Message-ID: <8838ff19-5e17-1d3a-f751-6b1e21d7d799@nvidia.com>
References: <20220118071952.1243143-1-hch@lst.de>
 <20220118071952.1243143-17-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v3XTQo/k3Ao88p0VxQnnj38+oL2wFdpJ5odlYOeRklo=;
 b=tuNHWo5YnOBhbreXH5o6kgeBTwTSKWVhKt52sB2MHhIzF3gkFxyjMZ+AzqNPva3P8nw+u7xEyebuRzaPARZhbCbx2a9Ya6xt+q0itShDJYJEcRV7UrDZrAQvaWm3rvvEaVyzGWX5eOT+FmYrC73eZO1wE6Bx18dXAh96HVcUg1hEzn0GhJ8YKSlFOkjwM7yWr8gJTjdlDPo8KXaTV1oFe5A/NteXnXOJAKnbxclGLZ+lMWPTbzeCHms+uz0NRAPD428lGqg1S7HlP5UcxXfajmvJ2XJ296Bz/I8RoeJx528gKQIfqjklzgIWttoY48LsQ6NHmmTrEQ4UEDQXGx9SUw==
In-Reply-To: <20220118071952.1243143-17-hch@lst.de>
Content-Language: en-US
Content-ID: <2F4563EDE021F847919851EF702ECCC8@namprd12.prod.outlook.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Mike Snitzer <snitzer@redhat.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Andrew Morton <akpm@linux-foundation.org>, "Md . Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, =?utf-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.co>, Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>, "ntfs3@lists.linux.dev" <ntfs3@l>

T24gMS8xNy8yMiAxMToxOSBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFBhc3MgdGhl
IGJsb2NrX2RldmljZSBhbmQgb3BlcmF0aW9uIHRoYXQgd2UgcGxhbiB0byB1c2UgdGhpcyBiaW8g
Zm9yIHRvDQo+IGJpb19hbGxvY19raW9jYiB0byBvcHRpbWl6ZSB0aGUgYXNzaWdtZW50Lg0KPiAN
Cj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IC0tLQ0K
DQoNCkxvb2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBu
dmlkaWEuY29tPg0KDQoNCg==
