From: Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>
Subject: Re: directory entries
Date: Wed, 3 Sep 2008 14:39:40 +0200
Message-ID: <20080903123940.GA14354@aardappel.13thmonkey.org>
References: <20080826132944.GA17045@aardappel.13thmonkey.org>
	<20080901.143956.08023399.ryusuke@osrg.net>
	<20080901110730.GA21008@aardappel.13thmonkey.org>
	<20080902.015156.126164477.ryusuke@osrg.net>
	<20080902150226.GA28292@aardappel.13thmonkey.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0906842966=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080902150226.GA28292-5cYspOl2ggRz6xQTk39kMVfVdRo2wo/d@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Mime-version: 1.0
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>


--===============0906842966==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Ryusuke, hi folks,

On Tue, Sep 02, 2008 at 05:02:26PM +0200, Reinoud Zandijk wrote:
> > >  I can't see why the DAT would need change.
> > 
> > As I mentioned above, we cannot use the past version of the DAT.  So,
> > to allow multiple forks, we have to maintain multiple lifetime
> > information for each virtual block address in the single DAT.
> 
> I dont think thats needed. In the case with no history retention at all all 
> snapshots will be retained anyway regardless of how they are created/forked 
> right? So each snapshot keeps mountable and updateable. There will only be 
> a number of ifiles alive for each snapshot one like its already now.
> 
> If you'd like you modify the GC to keep say the history for a specified 
> time it only means that it needs to keep the history for the specified time 
> for all the snapshots that can be mounted as `head'.

Hmmm, I forgot that the virtual adresses will get multiplexed unless new 
virtual adresses are used... that suxs. So basicly each virtual address 
needs an indicator on which head its on and if its not the current head, a 
new virtual address needs to be assigned on write... hmmm

maybe we should cancel the idea of multiple heads for now? :)

with regards,
Reinoud


--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (NetBSD)

iQEVAwUBSL6FjIKcNwBDyKpoAQLlXggAyS3quOERjAUc/VK+D0T/pHMo8l5Ymdzg
IyVvg8ROAAgzOmend1qC7CkUlnP1Xs/ESZexsfFUECYr3ZE3TKt/77U7YU1xextk
mckPmjWDp9JsM6dgvcEtoRsl/Mc4BUtZRwNX2tx5iSIJoij/CWowcgDSPLizA/RH
F54yJ37sgFt/N1ENi+r7rcBR19rWsE/AufTt+3VuonYhO2n74dRkmL5fHLuGYX9W
4XYiqcmCzUvimSxgUdkfXuWWuQhTWKPDHeO/vsmidxugFjZz/tr/Et4LxRO+tv+s
9/vqzNaNujrVbiOUBrcyi51tUiRIMaDu2vrd2EbugeqzA5WT1SmYLg==
=HBRE
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--

--===============0906842966==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0906842966==--
