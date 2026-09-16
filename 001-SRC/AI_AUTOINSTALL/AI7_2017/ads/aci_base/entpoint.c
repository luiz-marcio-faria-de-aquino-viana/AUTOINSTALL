#define ADS_CADAPI 1
#include <windows.h>
#include <adslib.h>

char      adsw_AppName[512];
char	  *ads_argVec = adsw_AppName;
char      ads_appname[512];
//HWND      adsw_hwndAcad;
HWND	  adsw_hwndAcad0;
HINSTANCE adsw_hInstance;

HWND      adsw_hWnd;
int       adsw_wait;

ads_matrix ads_identmat;

// Protos
int ADS_GetGlobals(char *appname,HWND *hwnd,HINSTANCE *hInstance);
void __declspec(dllexport) ADS_EntryPoint(HWND hWnd);


void __declspec(dllexport) ADS_EntryPoint(HWND hWnd) {
	adsw_hwndAcad0 = adsw_acadMainWnd();

	int i,j;
	for(i=0; i<=3; i++) for(j=0; j<=3; j++)	ads_identmat[i][j]=0.0;
	for(i=0; i<=3; i++) ads_identmat[i][i]=1.0;

	ADS_GetGlobals(adsw_AppName,&adsw_hwndAcad0,&adsw_hInstance);
	strncpy(ads_appname,adsw_AppName,sizeof(ads_appname)-1);
	ADS_main(1,&ads_argVec);
    return;
}

#if defined(ADS_OVERRIDEMEMORYFUNCS)
	#undef malloc
	#undef free
	#undef realloc
	#undef calloc

	void *malloc(size_t sizeBytes) {						
		return(ads_malloc(sizeBytes));
	}

	void free(void *pMemLoc) {	
		ads_free(pMemLoc);
	}

	void *realloc(void *pOldMemLoc, size_t sizeBytes) {	
		return(ads_realloc(pOldMemLoc,sizeBytes));
	}

	void *calloc(size_t sizeHowMany, size_t sizeBytesEach) {
		return(ads_calloc(sizeHowMany,sizeBytesEach));
	}
#endif
