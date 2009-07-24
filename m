From: Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>
Subject: Re: Crash...
Date: Fri, 24 Jul 2009 13:13:33 +0200
Message-ID: <20090724111333.GE23256@aardappel.13thmonkey.org>
References: <20090724.011249.110726474.ryusuke@osrg.net>
	<9cdbb57f0907231402i1a92cb4qfe5a9d81346a4665@mail.gmail.com>
	<20090724085803.GA23256@aardappel.13thmonkey.org>
	<20090724.194617.88653682.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090724.194617.88653682.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Hi Ryusuke,

On Fri, Jul 24, 2009 at 07:46:17PM +0900, Ryusuke Konishi wrote:
> We have implemented nilfs to allow smaller block sizes in order to
> support some devices such like DVD/CD-ROM or flash based ones.

sounds fine :) i had some ideas about using NiLFS on CD-R/DVD*R and some ideas
about refining NiLFS on flash based media.

For CD-R/DVD*R the last block written (or written several times) can be the
superblock so sequential media will work just fine. No use for a garbage
collector there ;)

For flash media, the entire first segment/erase block can be used to store the
superblock in; filling it up sequentially and when full, trigger the erase
block wiping :)

Idea?

With regards,
Reinoud
