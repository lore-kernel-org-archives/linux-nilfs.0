From: Daniel Baumann <daniel-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Subject: Re: proper name for userspace package?
Date: Thu, 30 Jul 2009 20:36:28 +0200
Message-ID: <4A71E82C.1040208@debian.org>
References: <4A71CA72.8080106@redhat.com>
	<20090731.023234.56054455.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090731.023234.56054455.ryusuke-sG5X7nlA6pw@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Ryusuke Konishi wrote:
>> The tarball is "nilfs-utils" but debian has "nilfs2-tools" - is there a
>> preference, or is this a debian convention that caused the rename?

it's my own aim to get some sort of uniformity with package names in
debian, so that we have $filesystem-tools for new packages. new means
basically almost anything after e2fsutils.

actually, i should rename it from nilfs2-tools to nilfs-tools.
unfortunately, in debian we have a quite stupid thing called NEW queue
which make such a simple rename have a penalty of 4 to 8 weeks of
waiting until ftp-masters unblock it. but i still might do that at some
point (unless Ryusuke dislikes it ;).

for fedora/rh, if you don't have people with a quirk for uniformity, you
might just want to go with the upstream name as it's the way of the
least surprise for the user.

Regards,
Daniel

-- 
Address:        Daniel Baumann, Burgunderstrasse 3, CH-4562 Biberist
Email:          daniel.baumann-uDfGT2BMUjhJc61us3aD9uTW4wlIGRCZ@public.gmane.org
Internet:       http://people.panthera-systems.net/~daniel-baumann/
