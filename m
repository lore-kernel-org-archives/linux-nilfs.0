From: "_" <aeneuman-hi6Y0CQ0nG0@public.gmane.org>
Subject: how to convert a root partition (ext4) to nilfs
Date: Thu, 23 Dec 2010 13:51:38 +0100
Message-ID: <20101223125138.254030@gmx.net>
References: <S1752760Ab0LWM0J/20101223122609Z+814@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <S1752760Ab0LWM0J/20101223122609Z+814-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

hello,

i hope my question isn't too foolish, but i really
couldn't find a consistent how-to on the net.
how can i 'convert' a existing root partition to
nilfs?

during my install of a current ubuntu derivative (10.10)
i had a mounted empty partition with nilfs but the installer
(respectively gparted) could not handle this partition. so
i was forced select another filesytem (ext4) for my root
partition.

now i wonder how i can 'convert' this root partition to nilfs,
respectively how can i accomplish a direct installation to
a nilfs formated partition on my next install.

i installed /boot on a separate partition (ext4) to have no/less
problems with grub.

thanks for your help in advance.
stefan

end
-- 
Empfehlen Sie GMX DSL Ihren Freunden und Bekannten und wir
belohnen Sie mit bis zu 100,- Euro! https://freundschaftswerbung.gmx.de
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
