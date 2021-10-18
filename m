From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH 01/30] block: move the SECTOR_SIZE related definitions to
 blk_types.h
Date: Mon, 18 Oct 2021 06:21:41 +0000
Message-ID: <5cc35e9a-35f4-4d14-8092-2079c7cecab9@nvidia.com>
References: <20211015132643.1621913-1-hch@lst.de>
 <20211015132643.1621913-2-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9D3dTg+R+I3ZacOuudzxWtnSiSug0urozqSOWCJeax0=;
 b=Rvm8VRMXv2L3kI6V8T7xt1fsy8gLYJSTfnqNa8wY+Q+sPtGj6l505Bd4eVcJp9pUBOzM5vL0vpIcWDDo0edGZ4lwafK1L+5/N/7c3OW97bshZtdog6J5mZMK9vIH5SZ00IzhG4RI9PkIWaMb1C+CuBMg0W6o3CTl4p02KgXbIps8Jj2it6sSRRnR81zuG41kt/Iuwv24BdUT3h5tsUyotB0FZb3y2RcYpYonbYMIlkCyKskFAlqivbdrHjhsA3ERMpnSheNhXmZC+FYz4sQkWTkqEdamGKeMfsv+8lbQfxe5cH6upY+QOxOD4Oo0fTYeo3GGHIQXXEuXWcLBBKMYXg==
In-Reply-To: <20211015132643.1621913-2-hch@lst.de>
Content-Language: en-US
Content-ID: <8FDA8D39C6C7234E8DB3CF40FCF6819B@namprd12.prod.outlook.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>, Theodore Ts'o <tytso@mit.edu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Anton Altaparmakov <anton@tuxera.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Kees Cook <keescook@chromium.org>, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, linux-raid@vger.kern

T24gMTAvMTUvMjEgMDY6MjYsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBFbnN1cmUgdGhl
c2UgYXJlIGFsd2F5cyBhdmFpbGFibGUgZm9yIGlubGluZXMgaW4gdGhlIHZhcmlvdXMgYmxvY2sg
bGF5ZXINCj4gaGVhZGVycy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2ln
IDxoY2hAbHN0LmRlPg0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1
bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KDQo=
